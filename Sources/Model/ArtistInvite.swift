////
///  ArtistInvite.swift
//

import SwiftyJSON

// Version 1: initial
let ArtistInviteVersion = 1

final class ArtistInvite: JSONAble, Groupable {
    struct Guide {
        let title: String
        let html: String
    }

    enum Status: String {
        case preview
        case open
        case closed
    }

    let id: String
    let title: String
    let shortDescription: String
    let submissionBody: String
    let longDescription: String
    let status: Status
    let openedAt: Date?
    let closedAt: Date?
    var guide: [Guide] = []
    var groupId: String { return "Editorial-\(id)" }
    override var description: String { return longDescription }

    init(
        id: String,
        title: String,
        shortDescription: String,
        submissionBody: String,
        longDescription: String,
        status: Status,
        openedAt: Date?,
        closedAt: Date?)
    {
        self.id = id
        self.title = title
        self.shortDescription = shortDescription
        self.submissionBody = submissionBody
        self.longDescription = longDescription
        self.status = status
        self.openedAt = openedAt
        self.closedAt = closedAt
        super.init(version: ArtistInviteVersion)
    }

    required init(coder: NSCoder) {
        let decoder = Coder(coder)
        id = decoder.decodeKey("id")
        title = decoder.decodeKey("title")
        shortDescription = decoder.decodeKey("shortDescription")
        submissionBody = decoder.decodeKey("submissionBody")
        longDescription = decoder.decodeKey("longDescription")
        status = Status(rawValue: decoder.decodeKey("status")) ?? .closed
        openedAt = decoder.decodeOptionalKey("openedAt")
        closedAt = decoder.decodeOptionalKey("closedAt")
        super.init(coder: coder)
    }

    override func encode(with coder: NSCoder) {
        let encoder = Coder(coder)
        encoder.encodeObject(id, forKey: "id")
        encoder.encodeObject(title, forKey: "title")
        encoder.encodeObject(shortDescription, forKey: "shortDescription")
        encoder.encodeObject(submissionBody, forKey: "submissionBody")
        encoder.encodeObject(longDescription, forKey: "longDescription")
        encoder.encodeObject(status.rawValue, forKey: "status")
        encoder.encodeObject(openedAt, forKey: "openedAt")
        encoder.encodeObject(closedAt, forKey: "closedAt")
        super.encode(with: coder)
    }

    override class func fromJSON(_ data: [String: Any]) -> JSONAble {
        let json = JSON(data)

        let id = json["id"].stringValue
        let title = json["title"].stringValue
        let shortDescription = json["short_description"].stringValue
        let submissionBody = json["submission_body_block"].stringValue
        let longDescription = json["description"].stringValue
        let status = Status(rawValue: json["status"].stringValue) ?? .closed
        let openedAt = json["opened_at"].stringValue.toDate()
        let closedAt = json["closed_at"].stringValue.toDate()

        let editorial = ArtistInvite(
            id: id,
            title: title,
            shortDescription: shortDescription,
            submissionBody: submissionBody,
            longDescription: longDescription,
            status: status,
            openedAt: openedAt,
            closedAt: closedAt)
        editorial.links = data["links"] as? [String: Any]

        return editorial
    }
}

extension ArtistInvite: JSONSaveable {
    var uniqueId: String? { return "ArtistInvite-\(id)" }
    var tableId: String? { return id }
}
