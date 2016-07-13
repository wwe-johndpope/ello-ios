////
///  LovesPageController.swift
//

import Foundation

class LovesPageController: IntroPageController {

    weak var lovesLabel: ElloLabel!
    @IBOutlet weak var getStartedButton: GreenElloButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        lovesLabel.font = .defaultBoldFont(18)
    }

    @IBAction func didTouchGetStarted(sender: AnyObject) {
        parentViewController?.dismissViewControllerAnimated(false, completion: nil)
    }
}
