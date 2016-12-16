////
///  Mapper.swift
//

import Foundation

public struct Mapper {

    public static func mapJSON(data: NSData) -> (AnyObject?, NSError?) {
        var error: NSError?
        var json: AnyObject?
        do {
            json = try NSJSONSerialization.JSONObjectWithData(data, options: [])
        } catch let error1 as NSError {
            error = error1
            json = nil
        }

        if json == nil && error != nil {
            let userInfo: [NSObject : AnyObject]? = ["data": data]
            error = NSError(domain: ElloErrorDomain, code: ElloErrorCode.JSONMapping.rawValue, userInfo: userInfo)
        }

        return (json, error)
    }

    public static func mapToObjectArray(dicts: [[String:AnyObject]], type: MappingType) -> [JSONAble] {
        let fromJSON = type.fromJSON
        return dicts.map { data in
            let jsonable = fromJSON(data: data)
            if let id = (jsonable as? JSONSaveable)?.tableId {
                ElloLinkedStore.sharedInstance.saveObject(jsonable, id: id, type: type)
            }
            return jsonable
        }
    }

    public static func mapToObject(object: AnyObject?, type: MappingType) -> JSONAble? {
        let fromJSON = type.fromJSON
        return (object as? [String:AnyObject]).flatMap { data in
            let jsonable = fromJSON(data: data)
            if let id = (jsonable as? JSONSaveable)?.tableId {
                ElloLinkedStore.sharedInstance.saveObject(jsonable, id: id, type: type)
            }
            return jsonable
        }
    }
}
