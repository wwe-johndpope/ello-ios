////
///  ProfileLinksPresenterSpec.swift
//

@testable import Ello
import Quick
import Nimble


class ProfileLinksPresenterSpec: QuickSpec {
    override func spec() {
        describe("ProfileLinksPresenter") {
            it("should assign links") {
                let user = User.stub([:])
                let view = ProfileLinksView()
                ProfileLinksPresenter.configure(view, user: user, currentUser: nil)
            }
        }
    }
}
