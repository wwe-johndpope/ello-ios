//
//  Category.swift
//  Ello
//
//  Created by Colin Gray on 6/14/2016.
//  Copyright (c) 2016 Ello. All rights reserved.
//

import SwiftyJSON

public let CategoryVersion = 1

public final class Category: JSONAble, Groupable {
    static let featured = Category(id: "meta1", name: InterfaceString.Discover.Featured, slug: "recommended", order: 0, level: .Meta)
    static let trending = Category(id: "meta2", name: InterfaceString.Discover.Trending, slug: "trending", order: 1, level: .Meta)
    static let recent = Category(id: "meta3", name: InterfaceString.Discover.Recent, slug: "recent", order: 2, level: .Meta)

    public let id: String
    public var groupId: String { return id }
    public let name: String
    public let slug: String
    public var cardURL: NSURL? { return nil }
    public let order: Int
    public let level: CategoryLevel
    public var endpoint: ElloAPI {
        switch level {
        case .Meta: return .Discover(type: DiscoverType(rawValue: slug)!)
        default: return .CategoryPosts(slug: slug)
        }
    }

    public init(id: String,
        name: String,
        slug: String,
        order: Int,
        level: CategoryLevel)
    {
        self.id = id
        self.name = name
        self.slug = slug
        self.order = order
        self.level = level
        super.init(version: CategoryVersion)
    }

    public required init(coder: NSCoder) {
        let decoder = Coder(coder)
        id = decoder.decodeKey("id")
        name = decoder.decodeKey("name")
        slug = decoder.decodeKey("slug")
        order = decoder.decodeKey("order")
        level = CategoryLevel(rawValue: decoder.decodeKey("level"))!
        super.init(coder: coder)
    }

    public override func encodeWithCoder(coder: NSCoder) {
        let encoder = Coder(coder)
        encoder.encodeObject(id, forKey: "id")
        encoder.encodeObject(name, forKey: "name")
        encoder.encodeObject(slug, forKey: "slug")
        encoder.encodeObject(order, forKey: "order")
        encoder.encodeObject(level.rawValue, forKey: "level")
        super.encodeWithCoder(coder)
    }

    override public class func fromJSON(data: [String: AnyObject], fromLinked: Bool = false) -> JSONAble {
        let json = JSON(data)
        let id = json["id"].stringValue
        let name = json["name"].stringValue
        let slug = json["slug"].stringValue
        let order = json["order"].intValue
        let level: CategoryLevel = CategoryLevel(rawValue: json["level"].stringValue) ?? .Tertiary
        return Category(id: id, name: name, slug: slug, order: order, level: level)
    }

}
