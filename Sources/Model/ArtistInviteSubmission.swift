////
///  ArtistInviteSubmission.swift
//

import SwiftyJSON
import Moya


@objc(ArtistInviteSubmission)
final class ArtistInviteSubmission: JSONAble, Groupable {
    // Version 1: initial
    // Version 2: artistInviteId, postId
    static let Version = 2

    let id: String
    let artistInviteId: String
    let postId: String
    var artistInvite: ArtistInvite? {
        return ElloLinkedStore.sharedInstance.getObject(self.artistInviteId, type: .artistInvitesType) as? ArtistInvite
    }
    let status: Status
    var actions: [Action] = []
    var groupId: String { return "ArtistInviteSubmission-\(id)" }

    enum Status: String {
        case approved
        case selected
        case unapproved
    }

    struct Action {
        enum Name {
            case approve
            case unapprove
            case select
            case unselect
            case other(String)

            init(_ name: String) {
                switch name {
                case "unapprove": self = .unapprove
                case "unselect": self = .unselect
                case "approve": self = .approve
                case "select": self = .select
                default: self = .other(name)
                }
            }

            var string: String {
                switch self {
                case .unapprove: return "unapprove"
                case .unselect: return "unselect"
                case .approve: return "approve"
                case .select: return "select"
                case let .other(string): return string
                }
            }
        }

        let statusChange: Status
        let name: Name
        let label: String
        let request: ElloRequest
        var endpoint: ElloAPI { return .customRequest(request, mimics: .artistInviteSubmissions) }

        var order: Int {
            switch name {
            case .unapprove: return 0
            case .approve: return 1
            case .unselect: return 2
            case .select: return 3
            case .other: return 4
            }
        }

        init(statusChange: Status, name: Name, label: String, request: ElloRequest) {
            self.statusChange = statusChange
            self.name = name
            self.label = label
            self.request = request
        }

        init?(name nameStr: String, json: JSON) {
            guard
                let parameters = json["body"].object as? [String: String],
                let statusChange = json["body"]["status"].string.flatMap({ Status(rawValue: $0) }),
                let label = json["label"].string,
                let method = json["method"].string.map({ $0.uppercased() }).flatMap({ Moya.Method(rawValue: $0) }),
                let url = json["href"].string.flatMap({ URL(string: $0) })
            else { return nil }

            self.init(statusChange: statusChange, name: Name(nameStr), label: label, request: ElloRequest(url: url, method: method, parameters: parameters))
        }
    }

    var post: Post? {
        return getLinkObject("post") as? Post
    }

    init(id: String, artistInviteId: String, postId: String, status: Status) {
        self.id = id
        self.artistInviteId = artistInviteId
        self.postId = postId
        self.status = status
        super.init(version: ArtistInviteSubmission.Version)
    }

    required init(coder: NSCoder) {
        let decoder = Coder(coder)
        let version: Int = decoder.decodeKey("version")
        id = decoder.decodeKey("id")
        if version > 1 {
            artistInviteId = decoder.decodeKey("artistInviteId")
            postId = decoder.decodeKey("postId")
        }
        else {
            artistInviteId = ""
            postId = ""
        }
        status = Status(rawValue: decoder.decodeKey("status") as String) ?? .unapproved
        let actions: [[String: Any]] = decoder.decodeKey("actions")
        self.actions = actions.flatMap { Action.decode($0, version: version) }
        super.init(coder: coder)
    }

    override func encode(with coder: NSCoder) {
        let encoder = Coder(coder)
        encoder.encodeObject(id, forKey: "id")
        encoder.encodeObject(artistInviteId, forKey: "artistInviteId")
        encoder.encodeObject(postId, forKey: "postId")
        encoder.encodeObject(status.rawValue, forKey: "status")
        encoder.encodeObject(actions.map { $0.encodeable }, forKey: "actions")
        super.encode(with: coder)
    }

    override class func fromJSON(_ data: [String: Any]) -> JSONAble {
        let json = JSON(data)

        let id = json["id"].stringValue
        let artistInviteId = json["artist_invite_id"].stringValue
        let postId = json["post_id"].stringValue
        let status = Status(rawValue: json["status"].stringValue) ?? .unapproved
        let submission = ArtistInviteSubmission(id: id, artistInviteId: artistInviteId, postId: postId, status: status)
        submission.links = data["links"] as? [String: Any]
        if let actions = data["actions"] as? [String: Any] {
            submission.actions = actions.flatMap { key, value in
                return Action(name: key, json: JSON(value))
            }.sorted { a, b in
                return a.order < b.order
            }
        }

        return submission
    }
}

extension ArtistInviteSubmission: JSONSaveable {
    var uniqueId: String? { return "ArtistInviteSubmission-\(id)" }
    var tableId: String? { return id }
}

extension ArtistInviteSubmission.Action {
    var encodeable: [String: Any] {
        let parameters: [String: Any] = request.parameters ?? [:]
        return [
            "statusChange": statusChange.rawValue,
            "name": name.string,
            "label": label,
            "url": request.url,
            "method": request.method.rawValue,
            "parameters": parameters,
        ]
    }

    static func decode(_ decodeable: [String: Any], version: Int) -> ArtistInviteSubmission.Action? {
        guard
            let statusChange = (decodeable["statusChange"] as? String).flatMap({ ArtistInviteSubmission.Status(rawValue: $0) }),
            let nameStr = decodeable["name"] as? String,
            let label = decodeable["label"] as? String,
            let url = decodeable["url"] as? URL,
            let method = (decodeable["method"] as? String).flatMap({ Moya.Method(rawValue: $0) }),
            let parameters = decodeable["parameters"] as? [String: String]
        else { return nil }

        return ArtistInviteSubmission.Action(statusChange: statusChange, name: Name(nameStr), label: label, request: ElloRequest(url: url, method: method, parameters: parameters))
    }
}
