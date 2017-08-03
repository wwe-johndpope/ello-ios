////
///  Regionable.swift
//

protocol Regionable: class {
    var kind: RegionKind { get }
    var isRepost: Bool { get set }
    func toJSON() -> [String: Any]
    func coding() -> NSCoding
}
