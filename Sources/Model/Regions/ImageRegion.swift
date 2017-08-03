////
///  ImageRegion.swift
//

import SwiftyJSON


let ImageRegionVersion = 1

@objc(ImageRegion)
final class ImageRegion: JSONAble, Regionable {
    var isRepost: Bool  = false

    // required
    let alt: String?
    // optional
    var url: URL?
    var buyButtonURL: URL?

    // links
    var asset: Asset? { return getLinkObject("assets") as? Asset }

// MARK: Initialization

    init(alt: String?)
    {
        self.alt = alt
        super.init(version: ImageRegionVersion)
    }

// MARK: NSCoding

    required init(coder: NSCoder) {
        let decoder = Coder(coder)
        // required
        self.isRepost = decoder.decodeKey("isRepost")
        // optional
        self.alt = decoder.decodeOptionalKey("alt")
        self.url = decoder.decodeOptionalKey("url")
        self.buyButtonURL = decoder.decodeOptionalKey("buyButtonURL")
        super.init(coder: coder)
    }

    override func encode(with encoder: NSCoder) {
        let coder = Coder(encoder)
        // required
        coder.encodeObject(alt, forKey: "alt")
        coder.encodeObject(isRepost, forKey: "isRepost")
        // optional
        coder.encodeObject(url, forKey: "url")
        coder.encodeObject(buyButtonURL, forKey: "buyButtonURL")
        super.encode(with: coder.coder)
    }

// MARK: JSONAble

    override class func fromJSON(_ data: [String: Any]) -> JSONAble {
        let json = JSON(data)
        // create region
        let imageRegion = ImageRegion(
            alt: json["data"]["alt"].string
            )
        // optional
        if var urlStr = json["data"]["url"].string {
            if urlStr.hasPrefix("//") {
                urlStr = "https:\(urlStr)"
            }
            imageRegion.url = URL(string: urlStr)
        }
        if let urlStr = json["link_url"].string {
            imageRegion.buyButtonURL = URL(string: urlStr)
        }
        // links
        imageRegion.links = data["links"] as? [String: Any]
        return imageRegion
    }

// MARK: Regionable

    let kind: RegionKind = .image

    func coding() -> NSCoding {
        return self
    }

    func toJSON() -> [String: Any] {
        var json: [String: Any]
        if let url = self.url?.absoluteString {
            json = [
                "kind": self.kind,
                "data": [
                    "alt": alt ?? "",
                    "url": url
                ],
            ]
        }
        else {
            json = [
                "kind": self.kind,
                "data": [:]
            ]
        }

        if let buyButtonURL = buyButtonURL {
            json["link_url"] = buyButtonURL.absoluteString
        }
        return json
    }
}
