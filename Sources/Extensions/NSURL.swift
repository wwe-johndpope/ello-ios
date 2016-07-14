////
///  NSURL.swift
//

extension NSURL {
    var hasGifExtension: Bool {
        return pathExtension?.lowercaseString == "gif"
    }
}

public extension NSURL {
    var absoluteStringWithoutProtocol: String {
        return (host ?? "") + (path ?? "")
    }
}
