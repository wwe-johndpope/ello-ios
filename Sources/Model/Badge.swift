////
///  User.swift
//

import SwiftyJSON


// version 1: initial
// amend: renamed 'link' to 'caption', kept coder/decoder as 'link'
let BadgeVersion: Int = 2

@objc
final class Badge: JSONAble {
    var slug: String
    var name: String
    var caption: String
    var url: URL?
    var interfaceImage: InterfaceImage?
    var imageURL: URL?
    var isFeatured: Bool { return slug == "featured" }

    let categories: [Category]?

    init(badge: Badge, categories: [Category]?) {
        self.slug = badge.slug
        self.name = badge.name
        self.caption = badge.caption
        self.url = badge.url
        self.interfaceImage = badge.interfaceImage
        self.imageURL = badge.imageURL
        self.categories = categories
        super.init(version: BadgeVersion)
    }

    init(slug: String,
        name: String,
        caption: String,
        url: URL?,
        imageURL: URL?
        )
    {
        self.slug = slug
        self.name = name
        self.caption = caption
        self.url = url
        switch slug {
        case "featured":
            self.interfaceImage = .badgeFeatured
        case "community":
            self.interfaceImage = .badgeCommunity
        case "experimental":
            self.interfaceImage = .badgeExperimental
        case "staff":
            self.interfaceImage = .badgeStaff
        case "spam":
            self.interfaceImage = .badgeSpam
        case "nsfw":
            self.interfaceImage = .badgeNsfw
        default:
            self.interfaceImage = nil
        }
        self.imageURL = imageURL
        self.categories = nil
        super.init(version: BadgeVersion)
    }

    static func lookup(slug: String) -> Badge? {
        return BadgesService.badges[slug]
    }

// MARK: NSCoding

    required init(coder: NSCoder) {
        let decoder = Coder(coder)
        self.slug = decoder.decodeKey("slug")
        self.name = decoder.decodeKey("name")
        self.caption = decoder.decodeKey("link")
        self.url = decoder.decodeOptionalKey("url")
        let interfaceImage: String? = decoder.decodeOptionalKey("interfaceImage")
        if let interfaceImage = interfaceImage {
            self.interfaceImage = InterfaceImage(rawValue: interfaceImage)
        }
        self.imageURL = decoder.decodeOptionalKey("imageURL")
        self.categories = nil
        super.init(coder: coder)
    }

    override func encode(with coder: NSCoder) {
        let encoder = Coder(coder)
        encoder.encodeObject(slug, forKey: "slug")
        encoder.encodeObject(name, forKey: "name")
        encoder.encodeObject(caption, forKey: "link")
        encoder.encodeObject(url, forKey: "url")
        encoder.encodeObject(interfaceImage?.rawValue, forKey: "interfaceImage")
        encoder.encodeObject(imageURL, forKey: "imageURL")
        super.encode(with: coder)
    }

    override class func fromJSON(_ data: [String: Any]) -> JSONAble {
        let json = JSON(data)
        return Badge(
            slug: json["slug"].stringValue,
            name: json["name"].stringValue,
            caption: json["learn_more_caption"].stringValue,
            url: json["learn_more_href"].string.flatMap { URL(string: $0) },
            imageURL: json["image"]["url"].string.flatMap { URL(string: $0) }
            )
    }

}
