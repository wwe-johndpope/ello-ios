////
///  LovesPageController.swift
//

import Foundation

class LovesPageController: IntroPageController {
    @IBAction func didTouchGetStarted(sender: AnyObject) {
        parentViewController?.dismissViewControllerAnimated(false, completion: nil)
    }
}
