////
///  JSONAble.swift
//

import YapDatabase
import Foundation

public typealias FromJSONClosure = (data: [String: AnyObject]) -> JSONAble

let JSONAbleVersion = 1

protocol JSONSaveable {
    var uniqueId: String? { get }
    var tableId: String? { get }
}

@objc(JSONAble)
public class JSONAble: NSObject, NSCoding {
    // links
    public var links: [String: AnyObject]?
    public let version: Int

    public init(version: Int) {
        self.version = version
        super.init()
    }

    public required init(coder aDecoder: NSCoder) {
        let decoder = Coder(aDecoder)
        self.links = decoder.decodeOptionalKey("links")
        self.version = decoder.decodeKey("version")
    }

    public func encodeWithCoder(encoder: NSCoder) {
        let coder = Coder(encoder)
        coder.encodeObject(links, forKey: "links")
        coder.encodeObject(version, forKey: "version")
    }

    public class func fromJSON(data: [String: AnyObject]) -> JSONAble {
        return JSONAble(version: JSONAbleVersion)
    }

    public func merge(other: JSONAble) -> JSONAble {
        return other
    }
}

// MARK: Links methods to get JSONAbles

extension JSONAble {
    public func getLinkObject(identifier: String) -> JSONAble? {
        var obj: JSONAble?
        if let id = links?[identifier]?["id"] as? String,
            collection = links?[identifier]?["type"] as? String
        {
            ElloLinkedStore.sharedInstance.readConnection.readWithBlock { transaction in
                obj = transaction.objectForKey(id, inCollection: collection) as? JSONAble
            }
        }
        else if let id = links?[identifier] as? String {
            ElloLinkedStore.sharedInstance.readConnection.readWithBlock { transaction in
                obj = transaction.objectForKey(id, inCollection: identifier) as? JSONAble
            }
        }
        return obj
    }

    public func getLinkArray(identifier: String) -> [JSONAble] {

        guard let ids =
            self.links?[identifier] as? [String] ??
            self.links?[identifier]?["ids"] as? [String]
        else { return [] }

        var arr = [JSONAble]()
        ElloLinkedStore.sharedInstance.readConnection.readWithBlock { transaction in
            for key in ids {
                if let jsonable = transaction.objectForKey(key, inCollection: identifier) as? JSONAble {
                    arr.append(jsonable)
                }
            }
        }
        return arr
    }

    public func addLinkObject(identifier: String, key: String, type: MappingType) {
        if links == nil { links = [String: AnyObject]() }
        links![identifier] = ["id": key, "type": type.rawValue]

    }

    public func addLinkObject(model: JSONAble, identifier: String, key: String, type: MappingType) {
        addLinkObject(identifier, key: key, type: type)
        ElloLinkedStore.sharedInstance.setObject(model, forKey: key, type: type)
    }

    public func clearLinkObject(identifier: String) {
        if links == nil { links = [String: AnyObject]() }
        links![identifier] = nil
    }

    public func addLinkArray(identifier: String, array: [String], type: MappingType) {
        if links == nil { links = [String: AnyObject]() }
        links![identifier] = ["ids": array, "type": type.rawValue]
    }
}
