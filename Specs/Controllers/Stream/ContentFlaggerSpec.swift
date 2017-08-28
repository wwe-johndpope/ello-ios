////
///  ContentFlaggerSpec.swift
//

@testable import Ello
import Quick
import Nimble
import Moya


class ContentFlaggerSpec: QuickSpec {

    override func spec() {

        var subject: ContentFlagger!
        var presentingController: UIViewController!
        beforeEach {
            presentingController = UIViewController()
            subject = ContentFlagger(presentingController: presentingController,
                flaggableId: "123",
                contentType: .post,
                commentPostId: nil)
            showController(presentingController)
        }

        context("post flagging") {
            it("presents an AlertViewController") {
                subject.displayFlaggingSheet()
                let presentedVC = subject.presentingController?.presentedViewController as! AlertViewController

                expect(presentedVC).to(beAKindOf(AlertViewController.self))
            }

            it("the correct kind is associated with each flag type") {
                subject.displayFlaggingSheet()
                let presentedVC = subject.presentingController?.presentedViewController as! AlertViewController

                let actions = presentedVC.actions

                let spamAction = actions[0]
                let violenceAction = actions[1]
                let copyrightAction = actions[2]
                let threateningAction = actions[3]
                let hateAction = actions[4]
                let adultAction = actions[5]
                let dontLikeAction = actions[6]

                expect(ContentFlagger.UserFlag(rawValue: spamAction.title)) == ContentFlagger.UserFlag.spam
                expect(ContentFlagger.UserFlag(rawValue: violenceAction.title)) == ContentFlagger.UserFlag.violence
                expect(ContentFlagger.UserFlag(rawValue: copyrightAction.title)) == ContentFlagger.UserFlag.copyright
                expect(ContentFlagger.UserFlag(rawValue: threateningAction.title)) == ContentFlagger.UserFlag.threatening
                expect(ContentFlagger.UserFlag(rawValue: hateAction.title)) == ContentFlagger.UserFlag.hate
                expect(ContentFlagger.UserFlag(rawValue: adultAction.title)) == ContentFlagger.UserFlag.adult
                expect(ContentFlagger.UserFlag(rawValue: dontLikeAction.title)) == ContentFlagger.UserFlag.dontLike
            }
        }
    }
}
