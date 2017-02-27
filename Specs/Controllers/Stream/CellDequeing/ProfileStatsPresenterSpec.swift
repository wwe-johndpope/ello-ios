////
///  ProfileStatsPresenterSpec.swift
//

@testable import Ello
import Quick
import Nimble


class ProfileStatsPresenterSpec: QuickSpec {
    override func spec() {
        describe("ProfileStatsPresenter") {
            it("should assign posts count") {
                let user = User.stub(["postsCount": 123])
                let view = ProfileStatsView()
                ProfileStatsPresenter.configure(view, user: user, currentUser: nil)
                expect(view.postsCount) == "123"
            }
            it("should round posts count") {
                let user = User.stub(["postsCount": 1_234])
                let view = ProfileStatsView()
                ProfileStatsPresenter.configure(view, user: user, currentUser: nil)
                expect(view.postsCount) == "1.2K"
            }

            it("should assign followers count") {
                let user = User.stub(["followersCount": 123])
                let view = ProfileStatsView()
                ProfileStatsPresenter.configure(view, user: user, currentUser: nil)
                expect(view.followersCount) == "123"
            }
            it("should support followers string") {
                let user = User.stub(["followersCount": "∞"])
                let view = ProfileStatsView()
                ProfileStatsPresenter.configure(view, user: user, currentUser: nil)
                expect(view.followersCount) == "∞"
            }

            it("should assign following count") {
                let user = User.stub(["followingCount": 123])
                let view = ProfileStatsView()
                ProfileStatsPresenter.configure(view, user: user, currentUser: nil)
                expect(view.followingCount) == "123"
            }
            it("should round following count") {
                let user = User.stub(["followingCount": 1_234_000])
                let view = ProfileStatsView()
                ProfileStatsPresenter.configure(view, user: user, currentUser: nil)
                expect(view.followingCount) == "1.2M"
            }

            it("should assign loves count") {
                let user = User.stub(["lovesCount": 123])
                let view = ProfileStatsView()
                ProfileStatsPresenter.configure(view, user: user, currentUser: nil)
                expect(view.lovesCount) == "123"
            }
            it("should round loves count") {
                let user = User.stub(["lovesCount": 1_567_000_000])
                let view = ProfileStatsView()
                ProfileStatsPresenter.configure(view, user: user, currentUser: nil)
                expect(view.lovesCount) == "1.6B"
            }
        }
    }
}
