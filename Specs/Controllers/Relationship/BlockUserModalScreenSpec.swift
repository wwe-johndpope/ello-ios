//
//  BlockUserModalScreenSpec.swift
//  Ello
//
//  Created by Colin Gray on 6/7/2016.
//  Copyright (c) 2016 Ello. All rights reserved.
//

@testable import Ello
import Quick
import Nimble


class BlockUserModalScreenSpec: QuickSpec {
    class FakeBlockUserModalController: UIViewController, BlockUserModalDelegate {
        var relationshipPriority: RelationshipPriority?
        var calledFlagTapped = false
        var calledCloseModal = false

        func updateRelationship(newRelationship: RelationshipPriority) {
            relationshipPriority = newRelationship
        }
        func flagTapped() {
            calledFlagTapped = true
        }
        func closeModal() {
            calledCloseModal = true
        }
    }

    override func spec() {
        describe("BlockUserModalScreen") {
            var subject: BlockUserModalScreen!
            var controller: FakeBlockUserModalController!
            var muteButton: UIButton!
            var blockButton: UIButton!
            var flagButton: UIButton!

            beforeEach {
                controller = FakeBlockUserModalController()
                subject = BlockUserModalScreen()
                controller.view = subject
                showController(controller)

                subject.setDetails(
                    userAtName: "@archer",
                    relationshipPriority: .Inactive
                    )

                muteButton = (subviewThatMatches(subject) { ($0 as? UIButton)?.currentTitle == InterfaceString.Relationship.MuteButton }) as! UIButton
                blockButton = (subviewThatMatches(subject) { ($0 as? UIButton)?.currentTitle == InterfaceString.Relationship.BlockButton }) as! UIButton
                flagButton = (subviewThatMatches(subject) { ($0 as? UIButton)?.currentTitle == InterfaceString.Relationship.FlagButton }) as! UIButton
            }

            describe("button targets") {

                describe("@muteButton") {
                    it("not selected") {
                        subject.setDetails(
                            userAtName: "@archer",
                            relationshipPriority: .Following
                            )
                        muteButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
                        expect(controller.relationshipPriority).to(equal(RelationshipPriority.Mute))
                    }

                    it("selected") {
                        subject.setDetails(
                            userAtName: "@archer",
                            relationshipPriority: .Mute
                            )
                        muteButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
                        expect(controller.relationshipPriority).to(equal(RelationshipPriority.Inactive))
                    }
                }

                describe("@blockButton") {
                    it("not selected") {
                        subject.setDetails(
                            userAtName: "@archer",
                            relationshipPriority: .Following
                            )
                        blockButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
                        expect(controller.relationshipPriority).to(equal(RelationshipPriority.Block))
                    }

                    it("selected") {
                        subject.setDetails(
                            userAtName: "@archer",
                            relationshipPriority: .Block
                            )
                        blockButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
                        expect(controller.relationshipPriority).to(equal(RelationshipPriority.Inactive))
                    }
                }

                describe("@flagButton") {
                    it("triggers") {
                        flagButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
                        expect(controller.calledFlagTapped).to(beTrue())
                    }
                }
            }
        }
    }
}
