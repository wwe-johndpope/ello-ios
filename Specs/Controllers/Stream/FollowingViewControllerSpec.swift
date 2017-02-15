////
///  FollowingViewControllerSpec.swift
//

@testable import Ello
import Quick
import Nimble
import SwiftyUserDefaults


class FollowingViewControllerSpec: QuickSpec {
    override func spec() {
        describe("FollowingViewController") {

            var subject: FollowingViewController!

            beforeEach {
                subject = FollowingViewController()
                showController(subject)
            }

            it("has the correct title") {
                expect(subject.title) == "Following"
            }

            it("has a streamKind of .following") {
                expect(subject.streamViewController.streamKind.name) == StreamKind.following.name
            }

            it("has a properly configured navigation bar") {
                expect(subject.navigationBar.items?.count) == 1
                let item = subject.navigationBar.items?.first

                expect(item?.leftBarButtonItems?.count) == 1
                expect(item?.rightBarButtonItems?.count) == 2
            }
        }
    }
}
