////
///  FriendsPageController.swift
//

import Foundation

class FriendsPageController: IntroPageController {

    @IBOutlet weak var friendsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        friendsLabel.font = .defaultBoldFont(18)
    }
}
