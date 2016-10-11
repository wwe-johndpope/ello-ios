////
///  ProfileBioPresenterSpec.swift
//

@testable import Ello
import Quick
import Nimble


class ProfileBioPresenterSpec: QuickSpec {
    override func spec() {
        describe("ProfileBioPresenter") {
            it("should assign bio") {
                let user = User.stub(["formattedShortBio": "<p>bio</p>"])
                let view = ProfileBioView()
                ProfileBioPresenter.configure(view, user: user, currentUser: nil)
                expect(view.bio) == "<p>bio</p>"
            }
        }
    }
}
