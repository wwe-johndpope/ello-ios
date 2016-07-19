////
///  StreamableViewController.swift
//

import Quick
import Nimble
import SSPullToRefresh


class StreamableViewControllerSpec: QuickSpec {
    override func spec() {

        var controller = StreamableViewController()

        describe("initialization") {

            it("can be instantiated from storyboard") {
                expect(controller).notTo(beNil())
            }

            it("is a BaseElloViewController") {
                expect(controller).to(beAKindOf(BaseElloViewController.self))
            }


            it("is a StreamableViewController") {
                expect(controller).to(beAKindOf(StreamableViewController.self))
            }
        }
    }
}
