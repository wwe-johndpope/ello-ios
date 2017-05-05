////
///  TextRegion.swift
//

import SwiftyJSON


let TextRegionVersion = 1

@objc(TextRegion)
final class TextRegion: JSONAble, Regionable {
    var isRepost: Bool = false

    let content: String

// MARK: Initialization

    init(content: String) {
        self.content = content
        super.init(version: TextRegionVersion)
    }

// MARK: NSCoding

    override func encode(with encoder: NSCoder) {
        let coder = Coder(encoder)
        coder.encodeObject(content, forKey: "content")
        coder.encodeObject(isRepost, forKey: "isRepost")
        super.encode(with: coder.coder)
    }

    required init(coder aDecoder: NSCoder) {
        let decoder = Coder(aDecoder)
        self.content = decoder.decodeKey("content")
        self.isRepost = decoder.decodeKey("isRepost")
        super.init(coder: decoder.coder)
    }

// MARK: JSONAble

    override class func fromJSON(_ data: [String: Any]) -> JSONAble {
        let json = JSON(data)
        let content = json["data"].stringValue
        return TextRegion(content: content)
    }

// MARK: Regionable

    var kind: String { return RegionKind.text.rawValue }

    func coding() -> NSCoding {
        return self
    }

    func toJSON() -> [String: Any] {
        return [
            "kind": self.kind,
            "data": self.content
        ]
    }
}

extension TextRegion {
    override var description: String {
        return "<\(type(of: self)): \"\(content)\">"
    }

    override var debugDescription: String { return description }
}
