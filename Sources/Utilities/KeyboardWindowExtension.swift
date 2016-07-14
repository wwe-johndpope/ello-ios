////
///  KeyboardWindowExtension.swift
//

import Foundation
import UIKit

public extension Keyboard {
    @objc
    func willShow(notification: NSNotification) {
        active = true
        setFromNotification(notification)
        endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let window = UIWindow.mainWindow
        bottomInset = window.frame.size.height - endFrame.origin.y
        external = endFrame.size.height > bottomInset

        postNotification(Notifications.KeyboardWillShow, value: self)
    }

    @objc
    func willHide(notification: NSNotification) {
        setFromNotification(notification)
        endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        bottomInset = 0

        let windowBottom = UIWindow.mainWindow.frame.size.height
        if endFrame.origin.y >= windowBottom {
            active = false
            external = false
        }
        else {
            external = true
        }

        postNotification(Notifications.KeyboardWillHide, value: self)
    }
}
