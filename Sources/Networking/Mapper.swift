////
///  Mapper.swift
//

struct Mapper {

    static func mapJSON(_ data: Data) -> (AnyObject?, NSError?) {
        var error: NSError?
        var json: AnyObject?
        do {
            json = try JSONSerialization.jsonObject(with: data) as AnyObject
        } catch let error1 as NSError {
            error = error1
            json = nil
        }

        if json == nil && error != nil {
            let userInfo: [AnyHashable: Any]? = ["data": data]
            error = NSError(domain: ElloErrorDomain, code: ElloErrorCode.jsonMapping.rawValue, userInfo: userInfo)
        }

        return (json, error)
    }

    static func mapToObjectArray(_ dicts: [[String: AnyObject]], type mappingType: MappingType) -> [JSONAble] {
        let fromJSON = mappingType.fromJSON
        return dicts.map { data in
            let jsonable = fromJSON(data)
            if let id = (jsonable as? JSONSaveable)?.tableId {
                ElloLinkedStore.sharedInstance.saveObject(jsonable, id: id, type: mappingType)
            }
            return jsonable
        }
    }

    static func mapToObject(_ object: AnyObject?, type mappingType: MappingType) -> JSONAble? {
        let fromJSON = mappingType.fromJSON
        return (object as? [String: AnyObject]).flatMap { data in
            let jsonable = fromJSON(data)
            if let id = (jsonable as? JSONSaveable)?.tableId {
                ElloLinkedStore.sharedInstance.saveObject(jsonable, id: id, type: mappingType)
            }
            return jsonable
        }
    }
}
