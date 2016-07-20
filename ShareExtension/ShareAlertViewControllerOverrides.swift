////
///  ShareAlertViewControllerOverrides.swift
//

import Foundation

public extension AlertViewController {
    // do not reference anything in the Keyboard
    // App Extensions are prohibited from using
    // some APIs
    func keyboardUpdateFrame(keyboard: Keyboard) {
    }
}
