////
///  RegionKindStreamCellTypeAddition.swift
//

import Foundation

extension RegionKind {
    public func streamCellTypes(regionable: Regionable) -> [StreamCellType] {
        switch self {
        case .Image:
            return [.Image(data: regionable)]
        case .Text:
            if let textRegion = regionable as? TextRegion {
                let content = textRegion.content
                let paragraphs = content.componentsSeparatedByString("</p>")
                return paragraphs.flatMap { (para: String) -> StreamCellType? in
                    if para == "" {
                        return nil
                    }

                    let newRegion = TextRegion(content: para + "</p>")
                    newRegion.isRepost = textRegion.isRepost
                    return .Text(data: newRegion)
                }
            }
            return []
        case .Embed:
            return [.Embed(data: regionable)]
        case .Unknown:
            return [.Unknown]
        }
    }
}
