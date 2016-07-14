//
//  OnboardingSpec.swift
//  Ello
//
//  Created by Colin Gray on 7/14/2015.
//  Copyright (c) 2015 Ello. All rights reserved.
//

import Quick
import Nimble
import SwiftyUserDefaults
@testable
import Ello


class OnboardingSpec: QuickSpec {
    override func spec() {
        describe("Onboarding") {
            let currentVersion: Int? = GroupDefaults["ViewedOnboardingVersion"].int
            afterSuite {
                GroupDefaults["ViewedOnboardingVersion"] = currentVersion
            }

            let expectations: [(localIsCurrent: Bool, webIsCurrent: Bool?, showOnboarding: Bool, saveOnboarding: Bool)] = [
                (localIsCurrent: true, webIsCurrent: nil, showOnboarding: false, saveOnboarding: true),
                (localIsCurrent: true, webIsCurrent: false, showOnboarding: false, saveOnboarding: true),
                (localIsCurrent: true, webIsCurrent: true, showOnboarding: false, saveOnboarding: false),
                (localIsCurrent: false, webIsCurrent: nil, showOnboarding: false, saveOnboarding: true),
                (localIsCurrent: false, webIsCurrent: false, showOnboarding: true, saveOnboarding: true),
                (localIsCurrent: false, webIsCurrent: true, showOnboarding: false, saveOnboarding: false),
            ]
            for (localIsCurrent, webIsCurrent, showOnboarding, saveOnboarding) in expectations {
                let title1: String
                if localIsCurrent { title1 = "localVersion is currentVersion" }
                else { title1 = "localVersion less than currentVersion" }
                let title2: String
                switch webIsCurrent {
                case .None:        title2 = "webVersion is nil"
                case .Some(true):  title2 = "webVersion is currentVersion"
                case .Some(false): title2 = "webVersion less than currentVersion"
                }
                describe("\(title1) and \(title2)") {
                    it("showOnboarding should be \(showOnboarding), saveOnboarding should be \(saveOnboarding)") {
                        if localIsCurrent {
                            GroupDefaults["ViewedOnboardingVersion"] = 1
                        }
                        else {
                            GroupDefaults["ViewedOnboardingVersion"] = 0
                        }
                        let onboarding = Onboarding()

                        var props: [String: AnyObject] = [:]
                        if case let .Some(webIsCurrent) = webIsCurrent {
                            props["onboardingVersion"] = (webIsCurrent ? 1 : 0)
                        }
                        let user: User = stub(props)

                        expect(onboarding.version) == (localIsCurrent ? 1 : 0)
                        if let webIsCurrent = webIsCurrent {
                            expect(user.onboardingVersion ?? -1) == (webIsCurrent ? 1 : 0)
                        }
                        else {
                            expect(user.onboardingVersion).to(beNil())
                        }
                        expect(onboarding.showOnboarding(user)) == showOnboarding
                        expect(onboarding.saveOnboarding(user)) == saveOnboarding
                    }
                }
            }
        }
    }
}
