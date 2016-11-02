////
///  ElloLinkedStore.swift
//

import Foundation
import YapDatabase

private let _ElloLinkedStore = ElloLinkedStore()


public struct ElloLinkedStore {

    public static var sharedInstance: ElloLinkedStore { return _ElloLinkedStore }
    public static var databaseName = "ello.sqlite"

    public var readConnection: YapDatabaseConnection {
        let connection = database.newConnection()
        connection.objectCacheLimit = 500
        return connection
    }
    public var writeConnection: YapDatabaseConnection
    private var database: YapDatabase

    public init() {
        ElloLinkedStore.deleteNonSharedDB()
        database = YapDatabase(path: ElloLinkedStore.databasePath())
        writeConnection = database.newConnection()
    }

    public func parseLinked(linked: [String:[[String: AnyObject]]], completion: ElloEmptyCompletion) {
        if AppSetup.sharedState.isTesting {
            parseLinkedSync(linked)
            completion()
        }
        else {
            inBackground {
                self.parseLinkedSync(linked)
                inForeground(completion)
            }
        }
    }

    // primarialy used for testing for now.. could be used for setting a model after it's fromJSON
    public func setObject(object: JSONAble, forKey key: String, type: MappingType) {
        writeConnection.readWriteWithBlock { transaction in
            transaction.setObject(object, forKey: key, inCollection: type.rawValue)
        }
    }

    public func getObject(key: String, type: MappingType) -> JSONAble? {
        var object: JSONAble?
        readConnection.readWithBlock { transaction in
            if transaction.hasObjectForKey(key, inCollection: type.rawValue) {
                object = transaction.objectForKey(key, inCollection: type.rawValue) as? JSONAble
            }
        }
        return object
    }

    public func saveObject(jsonable: JSONAble, id: String, type: MappingType) {
        self.writeConnection.readWriteWithBlock { transaction in
            if let existing = transaction.objectForKey(id, inCollection: type.rawValue) as? JSONAble {
                let merged = existing.merge(jsonable)
                transaction.replaceObject(merged, forKey: id, inCollection: type.rawValue)
            }
            else {
                transaction.setObject(jsonable, forKey: id, inCollection: type.rawValue)
            }
        }
    }

}

// MARK: Private
private extension ElloLinkedStore {

    static func deleteNonSharedDB(overrideDefaults overrideDefaults: NSUserDefaults? = nil) {
        let defaults: NSUserDefaults
        if let overrideDefaults = overrideDefaults {
            defaults = overrideDefaults
        }
        else {
            defaults = GroupDefaults
        }

        let didDeleteNonSharedDB = defaults["DidDeleteNonSharedDB"].bool ?? false
        if !didDeleteNonSharedDB {
            defaults["DidDeleteNonSharedDB"] = true
            ElloLinkedStore.removeNonSharedDB()
        }
    }

    static func removeNonSharedDB() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let baseDir: String
        if let firstPath = paths.first {
            baseDir = firstPath
        }
        else {
            baseDir = NSTemporaryDirectory()
        }

        let path: String
        if let baseURL = NSURL(string: baseDir) {
            path = baseURL.URLByAppendingPathComponent(ElloLinkedStore.databaseName)?.path ?? ""
        }
        else {
            path = ""
        }
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
            }
            catch _ {}
        }
    }

    static func databasePath() -> String {
        var path = ""
        if let baseURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(ElloGroupName) {
            path = baseURL.URLByAppendingPathComponent(ElloLinkedStore.databaseName)?.path ?? ""
        }
        return path
    }

    func parseLinkedSync(linked: [String: [[String: AnyObject]]]) {
        for (type, typeObjects): (String, [[String: AnyObject]]) in linked {
            guard let mappingType = MappingType(rawValue: type) else { continue }

            for object: [String: AnyObject] in typeObjects {
                guard let id = object["id"] as? String else { continue }

                let jsonable = mappingType.fromJSON(data: object)
                self.saveObject(jsonable, id: id, type: mappingType)
            }
        }
    }
}
