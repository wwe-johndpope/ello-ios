////
///  ArtistInviteSubmission.swift
//

import SwiftyJSON


final class ArtistInviteSubmission: JSONAble, Groupable {
    // Version 1: initial
    static let Version = 1

    let id: String
    var groupId: String { return "ArtistInviteSubmission-\(id)" }

    var post: Post? {
        return getLinkObject("post") as? Post
    }

    init(id: String) {
        self.id = id
        super.init(version: ArtistInviteSubmission.Version)
    }

    required init(coder: NSCoder) {
        let decoder = Coder(coder)
        id = decoder.decodeKey("id")
        super.init(coder: coder)
    }

    override func encode(with coder: NSCoder) {
        let encoder = Coder(coder)
        encoder.encodeObject(id, forKey: "id")
        super.encode(with: coder)
    }

    override class func fromJSON(_ data: [String: Any]) -> JSONAble {
        let json = JSON(data)

        let id = json["id"].stringValue
        let submission = ArtistInviteSubmission(id: id)
        submission.links = data["links"] as? [String: Any]

        return submission
    }
}

extension ArtistInviteSubmission: JSONSaveable {
    var uniqueId: String? { return "ArtistInviteSubmission-\(id)" }
    var tableId: String? { return id }
}
