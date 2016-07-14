////
///  Onboarding.swift
//

import SwiftyUserDefaults


private let _sharedInstance = Onboarding()
private let _currentVersion = 1

public class Onboarding {
    public private(set) var version: Int {
        didSet {
            GroupDefaults["ViewedOnboardingVersion"] = version
        }
    }

    public static var currentVersion: Int {
        return _currentVersion
    }

    public func updateVersionToLatest() {
        version = _currentVersion
    }

    public func reset() {
        version = 0
    }

    public class func shared() -> Onboarding {
        return _sharedInstance
    }

    init() {
        version = GroupDefaults["ViewedOnboardingVersion"].int ?? 0
    }

    // only show if webVersion is set and
    // localVersion < currentVersion and
    // webVersion < currentVersion
    public func showOnboarding(user: User) -> Bool {
        guard let webVersion = user.onboardingVersion else {
            return false
        }
        return version < _currentVersion && webVersion < _currentVersion
    }

    // save to API if webVersion is nil,
    // or less than currentVersion
    public func saveOnboarding(user: User) -> Bool {
        guard let webVersion = user.onboardingVersion else {
            return true
        }
        return webVersion < _currentVersion
    }

}
