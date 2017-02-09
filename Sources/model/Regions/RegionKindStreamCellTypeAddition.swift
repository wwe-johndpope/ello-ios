////
///  RegionKindStreamCellTypeAddition.swift
//

import Foundation

extension RegionKind {
    func streamCellTypes(_ regionable: Regionable) -> [StreamCellType] {
        switch self {
        case .image:
            return [.image(data: regionable)]
        case .text:
            if let textRegion = regionable as? TextRegion {
                let content = textRegion.content
                let paragraphs: [String] = content.components(separatedBy: "</p>").flatMap { (para: String) -> [String] in
                    guard para.trimmed() != "" else { return [] }

                    var subparas = para.components(separatedBy: "<br>")
                    guard
                        subparas.count > 1
                    else { return [para + "</p>"] }

                    let first = subparas.removeFirst()
                    return ["\(first)</p>"] + subparas.map({ "<p>\($0)</p>"})
                }.map { line in
                    let max = 7500
                    guard line.characters.count < max + 10 else {
                        let startIndex = line.characters.startIndex
                        let endIndex = line.characters.index(line.characters.startIndex, offsetBy: max)
                        return String(line.characters[startIndex..<endIndex]) + "&hellip;</p>" }
                    return line
                }
                return paragraphs.flatMap { (para: String) -> StreamCellType? in
                    if para == "" {
                        return nil
                    }

                    let newRegion = TextRegion(content: para)
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
