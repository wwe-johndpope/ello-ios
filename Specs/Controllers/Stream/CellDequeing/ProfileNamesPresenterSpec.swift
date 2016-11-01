////
///  ProfileNamesPresenterSpec.swift
//

@testable import Ello
import Quick
import Nimble


class ProfileNamesPresenterSpec: QuickSpec {
    override func spec() {
        describe("ProfileNamesPresenter") {
            it("should assign name and username") {
                let user = User.stub(["name": "jim", "username": "jimmy"])
                let view = ProfileNamesView()
                ProfileNamesPresenter.configure(view, user: user, currentUser: nil)
                expect(view.name) == "jim"
                expect(view.username) == "@jimmy"
            }
        }
    }
}
