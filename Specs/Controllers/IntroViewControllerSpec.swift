////
///  IntroViewControllerSpec.swift
//

import Ello
import Quick
import Nimble

class IntroViewControllerSpec: QuickSpec {
    override func spec() {
        describe("IntroViewController") {
            var controller = IntroViewController()
            describe("initialization") {
                beforeEach {
                    controller = IntroViewController()
                }

                it("can be instantiated") {
                    expect(controller).notTo(beNil())
                }

                it("is a UIViewController") {
                    expect(controller).to(beAKindOf(UIViewController.self))
                }

                it("is a IntroViewController") {
                    expect(controller).to(beAKindOf(IntroViewController.self))
                }
            }
            describe("snapshots") {
                let subject = IntroViewController()
                validateAllSnapshots(subject, named: "IntroViewController")
            }
        }
    }
}
