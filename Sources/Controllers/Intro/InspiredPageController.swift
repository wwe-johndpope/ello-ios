////
///  InspiredPageController.swift
//

import Foundation

class InspiredPageController: IntroPageController {

    weak var inspiredLabel: ElloLabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        inspiredLabel.font = .defaultBoldFont(18)
    }
}
