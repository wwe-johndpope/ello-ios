////
///  ProfileScreenSpec.swift
//

@testable import Ello
import Quick
import Nimble


class ProfileScreenSpec: QuickSpec {
    class MockDelegate: ProfileScreenDelegate {
        func mentionTapped() {}
        func hireTapped() {}
        func editTapped() {}
        func inviteTapped() {}
    }

    override func spec() {
        describe("ProfileScreen") {
            var subject: ProfileScreen!
            var delegate: MockDelegate!

            beforeEach {
                subject = ProfileScreen()
                delegate = MockDelegate()
                subject.delegate = delegate
                subject.coverImage.image = specImage(named: "specs-cover.jpg")
                
            }

            context("snapshots") {
                
                context("current user") {

                    validateAllSnapshots(named: "ProfileScreen_is_current_user") {
                        let user = User.stub(["id": "42", "username": "Archer", "relationshipPriority" : "self"])
                        subject.configureButtonsForCurrentUser()
                        subject.relationshipControl.userId = user.id
                        subject.relationshipControl.userAtName = user.atName
                        subject.relationshipControl.relationshipPriority = user.relationshipPriority
                        subject.showNavBars(CGPointZero)
                        return subject
                    }
                }

                context("not current user") {

                    context("IS hireable") {
                        validateAllSnapshots(named: "ProfileScreen_not_current_user_IS_hireable") {
                            let user = User.stub(["id": "42", "username": "Archer", "relationshipPriority" : "friend"])
                            subject.configureButtonsForNonCurrentUser(true)
                            subject.relationshipControl.userId = user.id
                            subject.relationshipControl.userAtName = user.atName
                            subject.relationshipControl.relationshipPriority = user.relationshipPriority
                            subject.showNavBars(CGPointZero)
                            return subject
                        }
                    }

                    context("is NOT hireable") {
                        validateAllSnapshots(named: "ProfileScreen_not_current_user_is_NOT_hireable") {
                            let user = User.stub(["id": "42", "username": "Archer", "relationshipPriority" : "noise"])
                            subject.configureButtonsForNonCurrentUser(false)
                            subject.relationshipControl.userId = user.id
                            subject.relationshipControl.userAtName = user.atName
                            subject.relationshipControl.relationshipPriority = user.relationshipPriority
                            subject.showNavBars(CGPointZero)
                            return subject
                        }
                    }
                }
            }
        }
    }

}
