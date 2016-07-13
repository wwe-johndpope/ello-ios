////
///  IntroPageController.swift
//

import Foundation
import Crashlytics

class IntroPageController: UIViewController {

    var pageIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isKindOfClass(WelcomePageController) {
            Crashlytics.sharedInstance().setObjectValue("IntroWelcome", forKey: CrashlyticsKey.StreamName.rawValue)
        }
        else if self.isKindOfClass(InspiredPageController) {
            Crashlytics.sharedInstance().setObjectValue("IntroInspired", forKey: CrashlyticsKey.StreamName.rawValue)
        }
        else if self.isKindOfClass(FriendsPageController) {
            Crashlytics.sharedInstance().setObjectValue("IntroFriends", forKey: CrashlyticsKey.StreamName.rawValue)
        }
        else if self.isKindOfClass(LovesPageController) {
            Crashlytics.sharedInstance().setObjectValue("IntroLoves", forKey: CrashlyticsKey.StreamName.rawValue)
        }
    }
}
