////
///  UIViewExtensionsSpec.swift
//

import Ello
import Quick
import Nimble


class UIViewSpec: QuickSpec {
    override func spec() {
        describe("UIView") {
            describe("addToView(:_)") {
                it("adds self to parent") {
                    let parent = UIView(frame: CGRectZero)
                    var subject: UIView?

                    subject = UIView(frame: CGRectZero)
                    subject?.addToView(parent)
                    expect(subject?.superview) == parent
                }
            }
        }
    }
}
