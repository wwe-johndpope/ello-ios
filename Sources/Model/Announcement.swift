////
///  Announcement.swift
//

import SwiftyJSON

let AnnouncementVersion = 1

@objc
public final class Announcement: JSONAble, Groupable {
    public let id: String
    public let header: String
    public let body: String
    public let ctaURL: NSURL?
    public let ctaCaption: String
    public let createdAt: NSDate
    public var image: Asset?
    public var imageURL: NSURL? { return image?.hdpi?.url }

    public var groupId: String { return "Announcement-\(id)" }

    public init(
        id: String,
        header: String,
        body: String,
        ctaURL: NSURL?,
        ctaCaption: String,
        createdAt: NSDate) {
        self.id = id
        self.header = header
        self.body = body
        self.ctaURL = ctaURL
        self.ctaCaption = ctaCaption
        self.createdAt = createdAt
        super.init(version: AnnouncementVersion)
    }

    public required init(coder: NSCoder) {
        let decoder = Coder(coder)
        id = decoder.decodeKey("id")
        header = decoder.decodeKey("header")
        body = decoder.decodeKey("body")
        ctaURL = decoder.decodeKey("ctaURL")
        ctaCaption = decoder.decodeKey("ctaCaption")
        createdAt = decoder.decodeKey("createdAt")
        image = decoder.decodeOptionalKey("image")
        super.init(coder: coder)
    }

    public override func encodeWithCoder(coder: NSCoder) {
        let encoder = Coder(coder)
        encoder.encodeObject(id, forKey: "id")
        encoder.encodeObject(header, forKey: "header")
        encoder.encodeObject(body, forKey: "body")
        encoder.encodeObject(ctaURL, forKey: "ctaURL")
        encoder.encodeObject(ctaCaption, forKey: "ctaCaption")
        encoder.encodeObject(createdAt, forKey: "createdAt")
        encoder.encodeObject(image, forKey: "image")
        super.encodeWithCoder(coder)
    }

    override public class func fromJSON(data: [String: AnyObject]) -> JSONAble {
        let json = JSON(data)
        let id = json["id"].stringValue
        let header = json["header"].stringValue
        let body = json["body"].stringValue
        let ctaURL = json["cta_href"].string.flatMap { NSURL(string: $0) }
        let ctaCaption = json["cta_caption"].stringValue
        let createdAt: NSDate = json["created_at"].string?.toNSDate() ?? NSDate()

        let announcement = Announcement(id: id,
            header: header,
            body: body,
            ctaURL: ctaURL,
            ctaCaption: ctaCaption,
            createdAt: createdAt
            )
        announcement.image = Asset.parseAsset("image_\(id)", node: data["image"] as? [String: AnyObject])
        return announcement
    }
}

extension Announcement: JSONSaveable {
    var uniqueId: String? { if let id = tableId { return "Announcement-\(id)" } ; return nil }
    var tableId: String? { return id }

}
