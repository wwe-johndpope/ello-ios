////
///  ArtistInviteSubmission.swift
//

import SwiftyJSON
import Moya


final class ArtistInviteSubmission: JSONAble, Groupable {
    // Version 1: initial
    static let Version = 1

    let id: String
    let status: Status
    var actions: [Action] = []
    var groupId: String { return "ArtistInviteSubmission-\(id)" }

    enum Status: String {
        case approved
        case selected
        case unapproved
    }

    struct Action {
        static let unapprove = Action(statusChange: .unapproved, name: .unapprove, label: InterfaceString.ArtistInvites.AdminUnapproveAction, url: URL(string: "")!, method: .patch)
        static let unselect = Action(statusChange: .approved, name: .unselect, label: InterfaceString.ArtistInvites.AdminUnselectAction, url: URL(string: "")!, method: .patch)
        static let approve = Action(statusChange: .approved, name: .approve, label: InterfaceString.ArtistInvites.AdminApproveAction, url: URL(string: "")!, method: .patch)
        static let select = Action(statusChange: .selected, name: .select, label: InterfaceString.ArtistInvites.AdminSelectAction, url: URL(string: "")!, method: .patch)

        enum Name {
            case unapprove
            case unselect
            case approve
            case select
            case other(String)
        }

        let statusChange: Status
        let name: Name
        let label: String
        let endpoint: ElloAPI

        init(statusChange: Status, name: Name, label: String, url: URL, method: Moya.Method) {
            self.statusChange = statusChange
            self.name = name
            self.label = label
            self.endpoint = .customRequest(url: url, method: method, mimics: .artistInviteSubmissions)
        }

        init?(name nameStr: String, json: JSON) {
            guard
                let statusChange = json["body"]["status"].string.flatMap({ Status(rawValue: $0) }),
                let label = json["label"].string,
                let method = json["method"].string.map({ $0.uppercased() }).flatMap({ Moya.Method(rawValue: $0) }),
                let url = json["href"].string.flatMap({ URL(string: $0) })
            else { return nil }

            let name: Name
            switch nameStr {
            case "unapprove": name = .unapprove
            case "unselect": name = .unselect
            case "approve": name = .approve
            case "select": name = .select
            default: name = .other(nameStr)
            }

            // self.statusChange = statusChange
            // self.label = label
            // self.endpoint = .customRequest(url: url, method: method, mimics: .artistInviteSubmissions)
            self.init(statusChange: statusChange, name: name, label: label, url: url, method: method)
        }

        var nextActions: [Action] {
            return []
        }
    }

    var post: Post? {
        return getLinkObject("post") as? Post
    }

    init(id: String, status: Status) {
        self.id = id
        self.status = status
        super.init(version: ArtistInviteSubmission.Version)
    }

    required init(coder: NSCoder) {
        let decoder = Coder(coder)
        id = decoder.decodeKey("id")
        status = Status(rawValue: decoder.decodeKey("status") as String) ?? .unapproved
        super.init(coder: coder)
    }

    override func encode(with coder: NSCoder) {
        let encoder = Coder(coder)
        encoder.encodeObject(id, forKey: "id")
        encoder.encodeObject(status.rawValue, forKey: "status")
        super.encode(with: coder)
    }

    override class func fromJSON(_ data: [String: Any]) -> JSONAble {
        let json = JSON(data)

        let id = json["id"].stringValue
        let status = Status(rawValue: json["status"].stringValue) ?? .unapproved
        let submission = ArtistInviteSubmission(id: id, status: status)
        submission.links = data["links"] as? [String: Any]
        if let actions = data["actions"] as? [String: Any] {
            submission.actions = actions.flatMap { key, value in
                return Action(name: key, json: JSON(value))
            }
        }

        return submission
    }
}

extension ArtistInviteSubmission: JSONSaveable {
    var uniqueId: String? { return "ArtistInviteSubmission-\(id)" }
    var tableId: String? { return id }
}
