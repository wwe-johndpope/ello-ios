////
///  Tmp.swift
//

struct Tmp {
    static let uniqDir = Tmp.uniqueName()

    static func fileExists(_ fileName: String) -> Bool {
        guard let fileURL = self.fileURL(fileName) else { return false }
        return FileManager.default.fileExists(atPath: fileURL.path)
    }

    static func directoryURL() -> URL? {
        guard let pathURL = URL(string: NSTemporaryDirectory()) else { return nil }
        let directoryName = pathURL.appendingPathComponent(Tmp.uniqDir).absoluteString
        return URL(fileURLWithPath: directoryName, isDirectory: true)
    }

    static func fileURL(_ fileName: String) -> URL? {
        guard let directoryURL = directoryURL() else { return nil }
        return directoryURL.appendingPathComponent(fileName)
    }

    static func uniqueName() -> String {
        return ProcessInfo.processInfo.globallyUniqueString
    }

    static func write(_ toDataable: ToData, to fileName: String) -> URL? {
        guard
            let data = toDataable.toData(),
            let directoryURL = self.directoryURL()
        else { return nil }

        do {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)

            if let fileURL = self.fileURL(fileName) {
                try? data.write(to: fileURL, options: [.atomic])
                return fileURL
            }
            return nil
        }
        catch {
            return nil
        }
    }

    static func read(_ fileName: String) -> Data? {
        guard
            fileExists(fileName),
            let fileURL = fileURL(fileName)
        else { return nil }
        return (try? Data(contentsOf: fileURL))
    }

    static func read(_ fileName: String) -> String? {
        guard
            let data: Data = read(fileName),
            let string = String(data: data, encoding: .utf8)
        else { return nil }
        return string
    }

    static func read(_ fileName: String) -> UIImage? {
        if let data: Data = read(fileName) {
            return UIImage(data: data)
        }
        return nil
    }

    static func remove(_ fileName: String) -> Bool {
        guard
            let filePath = fileURL(fileName)?.path,
            FileManager.default.fileExists(atPath: filePath)
        else { return false }

        do {
            try FileManager.default.removeItem(atPath: filePath)
            return true
        }
        catch {
            return false
        }
    }
}
