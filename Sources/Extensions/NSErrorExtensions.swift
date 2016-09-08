////
///  NSErrorExtensions.swift
//

import UIKit

extension NSError {
    var elloErrorMessage: String? {
        if let elloNetworkError = self.userInfo[NSLocalizedFailureReasonErrorKey] as? ElloNetworkError {
            return elloNetworkError.title
        }
        if let reason = self.userInfo[NSLocalizedFailureReasonErrorKey] as? String {
            return reason
        }
        return nil
    }

    public static func uncastableJSONAble() -> NSError {
        return NSError.networkError(nil, code: ElloErrorCode.JSONMapping)
    }

}
