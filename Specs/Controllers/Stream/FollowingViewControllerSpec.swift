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

            it("shows the more posts button when new content is available") {
                subject.newPostsButton.alpha = 0
                postNotification(NewContentNotifications.newFollowingContent, value: ())
                expect(subject.newPostsButton.alpha) == 1
            }

            it("hide the more posts button after pulling to refresh") {
                subject.newPostsButton.alpha = 1
                subject.streamWillPullToRefresh()
                expect(subject.newPostsButton.alpha) == 0
            }
        }
    }
}
