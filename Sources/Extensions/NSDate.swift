////
///  NSDate.swift
//

import Foundation

public extension NSDate {

    func toServerDateString() -> String {
        return ServerDateFormatter.stringFromDate(self)
    }

    func toHTTPDateString() -> String {
        return HTTPDateFormatter.stringFromDate(self)
    }

    var isInPast: Bool {
        let now = NSDate()
        return self.compare(now) == NSComparisonResult.OrderedAscending
    }

}

public func == (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func < (lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }
