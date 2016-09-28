////
///  UINavigationItemSpec.swift
//

import Quick
import Nimble


public class NavItemResponder: NSObject {
    static public func a() {}
    static public func b() {}
    static public func c() {}
    static public func d() {}
}

class UINavigationItemSpec: QuickSpec {
    override func spec() {
        describe("UINavigationItem") {
            let subject = UINavigationItem()

            describe("areRightButtonsTheSame(_:)") {
                let target = NavItemResponder()

                let newItemsSame = [
                    UIBarButtonItem(
                        barButtonSystemItem: .Camera,
                        target: target,
                        action: #selector(NavItemResponder.a)
                    ),
                    UIBarButtonItem(
                        barButtonSystemItem: .Camera,
                        target: target,
                        action: #selector(NavItemResponder.b)
                    )
                ]

                let newItemsDifferent = [
                    UIBarButtonItem(
                        barButtonSystemItem: .Camera,
                        target: target,
                        action: #selector(NavItemResponder.c)
                    ),
                    UIBarButtonItem(
                        barButtonSystemItem: .Camera,
                        target: target,
                        action: #selector(NavItemResponder.c)
                    )
                ]

                let rightItems = [
                    UIBarButtonItem(
                        barButtonSystemItem: .Camera,
                        target: target,
                        action: #selector(NavItemResponder.a)
                    ),
                        UIBarButtonItem(
                            barButtonSystemItem: .Camera,
                            target: target,
                            action: #selector(NavItemResponder.b)
                        )
                ]

                it("returns true when the arrays have similar value semantics") {
                    subject.rightBarButtonItems = rightItems
                    expect(subject.areRightButtonsTheSame(newItemsSame)) == true
                }

                it("returns fale when the arrays have disimilar value semantics") {
                    subject.rightBarButtonItems = rightItems
                    expect(subject.areRightButtonsTheSame(newItemsDifferent)) == false
                }

            }
        }
    }
}
