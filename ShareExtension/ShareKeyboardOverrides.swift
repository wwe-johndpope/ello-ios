////
///  ShareKeyboardOverrides.swift
//

import Foundation
import UIKit

public extension Keyboard {

    // App extensions do not have access to
    // UIApplication.sharedApplication, override
    // these two methods and remove sharedApplication
    // references in ShareExtension

    @objc
    func willShow(notification : NSNotification) {
        active = true
        setFromNotification(notification)
        endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        postNotification(Notifications.KeyboardWillShow, value: self)
    }

    @objc
    func willHide(notification : NSNotification) {
        setFromNotification(notification)
        postNotification(Notifications.KeyboardWillHide, value: self)
    }
}

