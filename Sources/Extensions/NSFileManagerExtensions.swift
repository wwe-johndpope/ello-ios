////
///  NSFileManagerExtensions.swift
//

import Foundation

public extension NSFileManager {

    class func ElloDocumentsDir() -> String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    }
}
