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

    public static func mapToObjectArray(dicts: [[String:AnyObject]], fromJSON: FromJSONClosure) -> [JSONAble] {
        return dicts.map { fromJSON(data: $0, fromLinked: false) }
    }

    public static func mapToObject(object: AnyObject?, fromJSON: FromJSONClosure) -> JSONAble? {
        return (object as? [String:AnyObject]).flatMap { fromJSON(data: $0, fromLinked: false) }
    }
}
