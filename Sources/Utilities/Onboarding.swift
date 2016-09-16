////
///  Onboarding.swift
//

import SwiftyUserDefaults


private let _sharedInstance = Onboarding()
private let _currentVersion = 2

public class Onboarding {
    public static var currentVersion: Int {
        return _currentVersion
    }

    public func updateVersionToLatest() {
        ProfileService().updateUserProfile(["web_onboarding_version": _currentVersion], success: { _ in }, failure: { _ in })
    }

    public class func shared() -> Onboarding {
        return _sharedInstance
    }

    init() {
    }

    // only show if webVersion is nil
    public func showOnboarding(user: User) -> Bool {
        return user.onboardingVersion == nil
    }

}
