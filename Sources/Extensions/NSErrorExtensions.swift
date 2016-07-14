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

}
