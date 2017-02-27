////
///  GroupDefaultsSpec.swift
//

@testable import Ello
import Quick
import Nimble


class GroupDefaultsSpec: QuickSpec {
    override func spec() {
        describe("GroupDefaults") {
            context("resetOnLogout") {
                beforeEach {
                    GroupDefaults[CurrentStreamKey] = 0
                    GroupDefaults["ElloImageUploadQuality"] = 0.25
                    GroupDefaults[StreamKind.notifications(category: nil).lastViewedCreatedAtKey] = Date()
                    GroupDefaults[StreamKind.announcements.lastViewedCreatedAtKey] = Date()
                    GroupDefaults[StreamKind.following.lastViewedCreatedAtKey] = Date()
                    GroupDefaults[ElloTab.discover.narrationDefaultKey] = true
                    GroupDefaults.resetOnLogout()
                }

                let expectations: [(String, Bool)] = [
                    (CurrentStreamKey, true),
                    ("ElloImageUploadQuality", true),
                    (StreamKind.notifications(category: nil).lastViewedCreatedAtKey, true),
                    (StreamKind.announcements.lastViewedCreatedAtKey, true),
                    (StreamKind.following.lastViewedCreatedAtKey, true),
                    (ElloTab.discover.narrationDefaultKey, false),
                ]
                for (key, isNil) in expectations {
                    it("should \(isNil ? "reset" : "leave") \(key)") {
                        if isNil {
                            expect(GroupDefaults[key].object).to(beNil())
                        }
                        else {
                            expect(GroupDefaults[key].object).notTo(beNil())
                        }
                    }
                }
            }
        }
    }
}
