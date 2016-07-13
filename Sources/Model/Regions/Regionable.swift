////
///  Regionable.swift
//

import Foundation

@objc
public protocol Regionable {
    var kind: String { get }
    var isRepost: Bool { get set }
    func toJSON() -> [String: AnyObject]
    func coding() -> NSCoding
}
