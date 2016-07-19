////
///  FakePersistentLayer.swift
//

import Ello


public class FakePersistentLayer: PersistentLayer {
    var object: [String]?

    init() { }

    public func setObject(value: AnyObject?, forKey: String) {
        object = value as? [String]
    }

    public func objectForKey(defaultName: String) -> AnyObject? {
        return object ?? []
    }
}
