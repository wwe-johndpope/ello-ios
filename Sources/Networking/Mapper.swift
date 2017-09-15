////
///  Mapper.swift
//

struct Mapper {

    static func mapJSON(_ data: Data) -> (Any?, NSError?) {
        var error: NSError?
        var json: Any?
        do {
            json = try JSONSerialization.jsonObject(with: data)
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

    static func mapToObjectArray(_ dicts: [[String: Any]], type mappingType: MappingType) -> [JSONAble] {
        let fromJSON = mappingType.fromJSON
        return dicts.map { data in
            let jsonable = fromJSON(data)
            if let id = (jsonable as? JSONSaveable)?.tableId {
                ElloLinkedStore.shared.saveObject(jsonable, id: id, type: mappingType)
            }
            return jsonable
        }
    }

    static func mapToObject(_ object: Any?, type mappingType: MappingType) -> JSONAble? {
        let fromJSON = mappingType.fromJSON
        return (object as? [String: Any]).flatMap { data in
            let jsonable = fromJSON(data)
            if let id = (jsonable as? JSONSaveable)?.tableId {
                ElloLinkedStore.shared.saveObject(jsonable, id: id, type: mappingType)
            }
            return jsonable
        }
    }
}
