////
///  RegionKindStreamCellTypeAddition.swift
//

extension RegionKind {
    func streamCellTypes(_ regionable: Regionable) -> [StreamCellType] {
        switch self {
        case .image:
            return [.image(data: regionable)]
        case .text:
            if let textRegion = regionable as? TextRegion {
                let content = textRegion.content

                var paragraphs: [String] = content.components(separatedBy: "</p>")
                if paragraphs.last == "" {
                    _ = paragraphs.removeLast()
                }
                let truncatedParagraphs = paragraphs.map { line -> String in
                        let max = 7500
                        guard line.characters.count < max + 10 else {
                            let startIndex = line.characters.startIndex
                            let endIndex = line.characters.index(line.characters.startIndex, offsetBy: max)
                            return String(line.characters[startIndex..<endIndex]) + "&hellip;</p>"
                        }
                        return line + "</p>"
                    }

                return truncatedParagraphs.flatMap { (text: String) -> StreamCellType? in
                    if text == "" {
                        return nil
                    }

                    let newRegion = TextRegion(content: text)
                    newRegion.isRepost = textRegion.isRepost
                    return .text(data: newRegion)
                }
            }
            return []
        case .embed:
            return [.embed(data: regionable)]
        case .unknown:
            return [.unknown]
        }
    }
}
