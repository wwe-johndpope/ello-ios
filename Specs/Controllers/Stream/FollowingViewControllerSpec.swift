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
                expect(subject.title) == ""
            }

            it("has a streamKind of .following") {
                expect(subject.streamViewController.streamKind.name) == StreamKind.following.name
            }

            it("has a properly configured navigation bar") {
                expect(subject.navigationBar.items?.count) == 1
                let item = subject.navigationBar.items?.first

                expect(item?.leftBarButtonItems?.count) == 1
                expect(item?.rightBarButtonItems?.count) == 1
            }

            it("shows the more posts button when new content is available") {
                subject.newPostsButton.alpha = 0
                postNotification(NewContentNotifications.newFollowingContent, value: ())
                expect(subject.newPostsButton.alpha) == 1
            }

            it("hide the more posts button after scrolling") {
                subject.newPostsButton.alpha = 1
                let scrollView = subject.streamViewController.collectionView
                scrollView.contentOffset = .zero
                subject.streamViewDidScroll(scrollView: scrollView)
                expect(subject.newPostsButton.alpha) == 0
            }
        }
    }
}
