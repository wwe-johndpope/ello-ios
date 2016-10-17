////
///  ProfileViewControllerSpec.swift
//

@testable import Ello
import Moya
import Quick
import Nimble


class ProfileViewControllerSpec: QuickSpec {
    override func spec() {
        beforeEach {
            ElloLinkedStore.sharedInstance.writeConnection.readWriteWithBlock { transaction in
                transaction.removeObjectForKey("42", inCollection: "users")
            }
        }

        describe("ProfileViewController") {
            let currentUser: User = stub([:])

            describe("contentInset") {
                var subject: ProfileViewController!
                beforeEach {
                    subject = ProfileViewController(userParam: "42")
                    subject.currentUser = currentUser
                    UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .None)
                    showController(subject)
                }

                it("does not update the top inset") {
                    expect(subject.streamViewController.contentInset.top) == 0
                }
            }

            context("when displaying the currentUser") {
                var currentUser: User!
                var subject: ProfileViewController!
                var screen: ProfileScreen!

                beforeEach {
                    currentUser = User.stub(["id": "42"])
                    subject = ProfileViewController(user: currentUser)
                    subject.currentUser = currentUser
                    showController(subject)
                    screen = subject.view as! ProfileScreen
                }

                it("does not have a 'more following options' Button") {
                    let rightButtons = subject.elloNavigationItem.rightBarButtonItems
                    expect(rightButtons?.count ?? 0) == 0
                }

                context("collaborateable and hireable don't affect currentUser profile") {
                    let expectations: [(Bool, Bool)] = [
                        (true, true),
                        (true, false),
                        (false, true),
                        (false, false),
                        ]
                    for (isCollaborateable, isHireable) in expectations {
                        context("user \(isCollaborateable ? "is" : "is not") collaborateable and \(isHireable ? "is" : "is not") hireable") {
                            beforeEach {
                                currentUser = User.stub(["id": "42", "isCollaborateable": isCollaborateable, "isHireable": isHireable])
                                subject = ProfileViewController(user: currentUser)
                                subject.currentUser = currentUser
                                showController(subject)
                                screen = subject.view as! ProfileScreen
                            }
                            it("has hidden mentionButton") {
                                expect(screen.mentionButton.hidden) == true
                            }
                            it("has hidden hireButton") {
                                expect(screen.hireButton.hidden) == true
                            }
                        }
                    }
                }
            }

            context("when NOT displaying the currentUser") {
                var currentUser: User!
                var subject: ProfileViewController!
                var screen: ProfileScreen!

                beforeEach {
                    currentUser = User.stub(["id": "not42"])
                    subject = ProfileViewController(userParam: "42")
                    subject.currentUser = currentUser
                    showController(subject)
                    screen = subject.view as! ProfileScreen
                }

                it("has 'share' and 'more following options' buttons") {
                    expect(subject.elloNavigationItem.rightBarButtonItems?.count) == 2
                }

                let expectations: [(collaborateable: Bool, hireable: Bool, collaborateButton: Bool, hireButtonVisible: Bool, mentionButtonVisible: Bool)] = [
                    (collaborateable: true, hireable: true, collaborateButton: true, hireButtonVisible: true, mentionButtonVisible: false),
                    // (collaborateable: true, hireable: false, collaborateButton: true, hireButtonVisible: false, mentionButtonVisible: false),
                    (collaborateable: false, hireable: true, collaborateButton: false, hireButtonVisible: true, mentionButtonVisible: false),
                    (collaborateable: false, hireable: false, collaborateButton: false, hireButtonVisible: false, mentionButtonVisible: true),
                    ]
                for (collaborateable, hireable, collaborateButton, hireButtonVisible, mentionButtonVisible) in expectations {
                    context("collaborateable \(collaborateable) and hireable \(hireable) affect profile buttons") {
                        beforeEach {
                            ElloProvider.sharedProvider = ElloProvider.RecordedStubbingProvider([
                                RecordedResponse(endpoint: .UserStream(userParam: "any"), responseClosure: { _ in
                                    let data = stubbedData("users_user_details")
                                    var json = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String: AnyObject]
                                    var user = json["users"] as! [String: AnyObject]
                                    user["is_collaborateable"] = collaborateable
                                    user["is_hireable"] = hireable
                                    json["users"] = user
                                    let modData = try! NSJSONSerialization.dataWithJSONObject(json, options: [])
                                    return .NetworkResponse(200, modData)
                                }),
                                ])

                            currentUser = User.stub([:])
                            subject = ProfileViewController(userParam: "any")
                            subject.currentUser = currentUser
                            showController(subject)
                            screen = subject.view as! ProfileScreen
                        }

                        it("user \(collaborateable ? "is" : "is not") collaborateable") {
                            expect(subject.user?.isCollaborateable) == collaborateable
                        }
                        it("has \(collaborateButton ? "visible" : "hidden") collaborateButton") {
                            expect(screen.collaborateButton.hidden) == collaborateButton
                        }

                        it("user \(hireable ? "is" : "is not") hireable") {
                            expect(subject.user?.isHireable) == hireable
                        }
                        it("has \(hireButtonVisible ? "visible" : "hidden") hireButton") {
                            expect(screen.hireButton.hidden) == !hireButtonVisible
                        }

                        it("has \(mentionButtonVisible ? "visible" : "hidden") mentionButton") {
                            expect(screen.mentionButton.hidden) == !mentionButtonVisible
                        }
                    }
                }
            }

            context("when displaying a private user") {
                var currentUser: User!
                var subject: ProfileViewController!

                beforeEach {
                    ElloProvider.sharedProvider = ElloProvider.RecordedStubbingProvider([
                        RecordedResponse(endpoint: .UserStream(userParam: "50"), response: .NetworkResponse(200,
                            stubbedData("profile__no_sharing")
                            )),
                        ])

                    currentUser = User.stub(["id": "not50"])
                    subject = ProfileViewController(userParam: "50")
                    subject.currentUser = currentUser
                    showController(subject)
                }

                it("only has a 'more following options' button") {
                    expect(subject.elloNavigationItem.rightBarButtonItems?.count) == 1
                }
            }

            describe("tapping more button") {
                var user: User!
                var subject: ProfileViewController!

                beforeEach {
                    user = User.stub(["id": "42"])
                    subject = ProfileViewController(userParam: user.id)
                    subject.currentUser = currentUser
                    showController(subject)
                }

                it("launches the block modal") {
                    subject.moreButtonTapped()
                    let presentedVC = subject.presentedViewController
                    expect(presentedVC).notTo(beNil())
                    expect(presentedVC).to(beAKindOf(BlockUserModalViewController))
                }
            }


            context("with successful request") {
                var user: User!
                var subject: ProfileViewController!

                beforeEach {
                    subject = ProfileViewController(userParam: "42")
                    subject.currentUser = currentUser
                    showController(subject)
                    user = subject.user!
                }

                describe("@moreButton") {
                    it("not selected block") {
                        user.relationshipPriority = .Inactive
                        subject.moreButtonTapped()
                        let presentedVC = subject.presentedViewController as! BlockUserModalViewController
                        presentedVC.updateRelationship(.Block)
                        expect(user.relationshipPriority) == RelationshipPriority.Block
                    }

                    it("not selected mute") {
                        user.relationshipPriority = .Inactive
                        subject.moreButtonTapped()
                        let presentedVC = subject.presentedViewController as! BlockUserModalViewController
                        presentedVC.updateRelationship(.Mute)
                        expect(user.relationshipPriority) == RelationshipPriority.Mute
                    }

                    it("selected block") {
                        user.relationshipPriority = .Block
                        subject.moreButtonTapped()
                        let presentedVC = subject.presentedViewController as! BlockUserModalViewController
                        presentedVC.updateRelationship(.Inactive)
                        expect(user.relationshipPriority) == RelationshipPriority.Inactive
                    }

                    it("selected mute") {
                        user.relationshipPriority = .Mute
                        subject.moreButtonTapped()
                        let presentedVC = subject.presentedViewController as! BlockUserModalViewController
                        presentedVC.updateRelationship(.Inactive)
                        expect(user.relationshipPriority) == RelationshipPriority.Inactive
                    }

                }
            }

            context("with failed request") {
                var user: User!
                var subject: ProfileViewController!

                beforeEach {
                    subject = ProfileViewController(userParam: "42")
                    subject.currentUser = currentUser
                    showController(subject)
                    user = subject.user!
                    ElloProvider.sharedProvider = ElloProvider.ErrorStubbingProvider()
                }

                describe("@moreButton") {
                    it("not selected block") {
                        user.relationshipPriority = .Inactive
                        subject.moreButtonTapped()
                        let presentedVC = subject.presentedViewController as! BlockUserModalViewController
                        presentedVC.updateRelationship(.Block)
                        expect(user.relationshipPriority).to(equal(RelationshipPriority.Inactive))
                    }

                    it("not selected mute") {
                        user.relationshipPriority = .Inactive
                        subject.moreButtonTapped()
                        let presentedVC = subject.presentedViewController as! BlockUserModalViewController
                        presentedVC.updateRelationship(.Mute)
                        expect(user.relationshipPriority).to(equal(RelationshipPriority.Inactive))
                    }

                    it("selected block") {
                        user.relationshipPriority = .Block
                        subject.moreButtonTapped()
                        let presentedVC = subject.presentedViewController as! BlockUserModalViewController
                        presentedVC.updateRelationship(.Inactive)
                        expect(user.relationshipPriority).to(equal(RelationshipPriority.Block))
                    }

                    it("selected mute") {
                        user.relationshipPriority = .Mute
                        subject.moreButtonTapped()
                        let presentedVC = subject.presentedViewController as! BlockUserModalViewController
                        presentedVC.updateRelationship(.Inactive)
                        expect(user.relationshipPriority).to(equal(RelationshipPriority.Mute))
                    }
                }
            }

            xcontext("snapshots") {
                var subject: ProfileViewController!
                beforeEach {
                    subject = ProfileViewController(userParam: "42")
                    subject.currentUser = currentUser
                }
                validateAllSnapshots { return subject }
            }
            
            xcontext("snapshots - currentUser") {
                let user: User = stub([:])
                var subject: ProfileViewController!
                beforeEach {
                    subject = ProfileViewController(user: user)
                    showController(subject)
                    subject.currentUser = user
                    subject.updateUser(user)
                }
                validateAllSnapshots { return subject }
            }
        }
    }
}
