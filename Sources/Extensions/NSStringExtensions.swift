////
///  NSStringExtensions.swift
//

import Foundation

public extension NSString {
    func toNSDate(formatter: NSDateFormatter = ServerDateFormatter) -> NSDate? {
        return formatter.dateFromString(self as String)
    }
}
