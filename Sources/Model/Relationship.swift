//
//  Relationship.swift
//  Ello
//
//  Created by Gordon Fontenot on 3/11/15.
//  Copyright (c) 2015 Ello. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum RelationshipPriority: String {
    case Friend = "friend"
    case Noise = "noise"
    case Block = "block"
    case Mute = "mute"
    case Inactive = "inactive"
    case None = "none"
    case Null = "null"
    case Me = "self"

    static let all = [Friend, Noise, Block, Mute, Inactive, None, Null, Me]

    public init(stringValue: String) {
        self = RelationshipPriority(rawValue: stringValue) ?? .None
    }
}

let RelationshipVersion = 1

public final class Relationship: JSONAble {

    // active record
    public let id: String
    public let createdAt: NSDate
    // required
    public let ownerId: String
    public let subjectId: String
    // computed
    public var owner: User? {
        return ElloLinkedStore.sharedInstance.getObject(self.ownerId, inCollection: MappingType.UsersType.rawValue) as? User
    }

    public var subject: User? {
        return ElloLinkedStore.sharedInstance.getObject(self.subjectId, inCollection: MappingType.UsersType.rawValue) as? User
    }

    public init(id: String, createdAt: NSDate, ownerId: String, subjectId: String) {
        self.id = id
        self.createdAt = createdAt
        self.ownerId = ownerId
        self.subjectId = subjectId
        super.init(version: RelationshipVersion)
    }

// MARK: NSCoding

    public required init(coder aDecoder: NSCoder) {
        let decoder = Coder(aDecoder)
        // active record
        self.id = decoder.decodeKey("id")
        self.createdAt = decoder.decodeKey("createdAt")
        // required
        self.ownerId = decoder.decodeKey("ownerId")
        self.subjectId = decoder.decodeKey("subjectId")
        super.init(coder: decoder.coder)
    }

    public override func encodeWithCoder(encoder: NSCoder) {
        let coder = Coder(encoder)
        // active record
        coder.encodeObject(id, forKey: "id")
        coder.encodeObject(createdAt, forKey: "createdAt")
        // required
        coder.encodeObject(ownerId, forKey: "ownerId")
        coder.encodeObject(subjectId, forKey: "subjectId")
        super.encodeWithCoder(coder.coder)
    }

// MARK: JSONAble

    override public class func fromJSON(data:[String: AnyObject], fromLinked: Bool = false) -> JSONAble {
        let json = JSON(data)
        var createdAt: NSDate
        if let date = json["created_at"].stringValue.toNSDate() {
            // good to go
            createdAt = date
        }
        else {
            createdAt = NSDate()
            // send data to segment to try to get more data about this
            Tracker.sharedTracker.createdAtCrash("Relationship", json: json.rawString())
        }
        var relationship = Relationship(
            id: json["id"].stringValue,
            createdAt: createdAt,
            ownerId: json["links"]["owner"]["id"].stringValue,
            subjectId: json["links"]["subject"]["id"].stringValue
        )
        return relationship
    }
}
