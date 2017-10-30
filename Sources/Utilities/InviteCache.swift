////
///  InviteCache.swift
//


struct InviteCache {
    static let Key = "ElloInviteCache"
    var cache: [String]

    init() {
        if let existing = GroupDefaults[InviteCache.Key].array as? [String] {
            cache = existing
        }
        else {
            cache = []
        }
    }

    mutating func saveInvite(_ contactID: String) {
        guard !has(contactID) else { return }

        cache.append(contactID)
        GroupDefaults[InviteCache.Key] = cache
    }

    func has(_ contactID: String) -> Bool {
        return cache.contains(contactID)
    }

    mutating func clear() {
        cache = []
        GroupDefaults[InviteCache.Key] = nil
    }
}
