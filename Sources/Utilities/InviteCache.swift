////
///  InviteCache.swift
//

import Foundation

public struct InviteCache {
    var cache: ObjectCache<NSString>

    public init() {
        cache = ObjectCache<NSString>(name: "ElloInviteCache")
        cache.load()
    }

    public init(persistentLayer: PersistentLayer) {
        cache = ObjectCache<NSString>(name: "ElloInviteCache", persistentLayer: persistentLayer)
        cache.load()
    }

    public func saveInvite(contactID: String) {
        if has(contactID) { return }
        cache.append(contactID)
    }

    public func has(contactID: String) -> Bool {
        return cache.getAll().contains(contactID)
    }
}
