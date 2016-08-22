////
///  DiscoverViewControllerSpec.swift
//

import Ello
import Quick
import Nimble


class DiscoverViewControllerSpec: QuickSpec {
    override func spec() {

        describe("initialization") {
            var controller: DiscoverViewController!
            beforeEach {
                controller = DiscoverViewController()
            }

            it("can be instantiated from storyboard") {
                expect(controller).notTo(beNil())
            }

            it("is a BaseElloViewController") {
                expect(controller).to(beAKindOf(BaseElloViewController.self))
            }

            it("is a DiscoverViewController") {
                expect(controller).to(beAKindOf(DiscoverViewController.self))
            }
        }
    }
}
