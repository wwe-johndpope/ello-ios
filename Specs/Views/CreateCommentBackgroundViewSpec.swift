////
///  CreateCommentBackgroundViewSpec.swift
//

import Ello
import Quick
import Nimble


class CreateCommentBackgroundViewSpec: QuickSpec {
    override func spec() {
        describe("basic view stuff") {
            it("is a view") {
                expect(CreateCommentBackgroundView()).to(beAKindOf(UIView))
                expect(CreateCommentBackgroundView(frame: CGRectZero)).to(beAKindOf(UIView))
            }
        }
    }
}
