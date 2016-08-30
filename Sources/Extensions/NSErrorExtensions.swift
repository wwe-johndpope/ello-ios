////
///  NSErrorExtensions.swift
//

import UIKit

extension NSError {
    var elloErrorMessage: String? {
        if let elloNetworkError = self.userInfo[NSLocalizedFailureReasonErrorKey] as? ElloNetworkError {
            return elloNetworkError.title
        }
        return nil
    }

    public static func uncastableJSONAble() -> NSError {
        return NSError.networkError(nil, code: ElloErrorCode.JSONMapping)
    }

}
