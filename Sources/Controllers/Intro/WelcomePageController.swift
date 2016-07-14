////
///  WelcomePageController.swift
//

import Foundation

class WelcomePageController: IntroPageController {

    weak var welcomeLabel: ElloLabel!
    @IBOutlet weak var elloLogoImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.font = .defaultBoldFont(18)
    }
}
