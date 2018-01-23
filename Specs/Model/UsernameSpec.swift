////
///  UsernameSpec.swift
//

@testable import Ello
import Quick
import Nimble


class UsernameSpec: QuickSpec {
    override func spec() {
        describe("Username") {
            describe("atName") {
                it("returns the correct value") {
                    let username = Username(username: "bob")

                    expect(username.atName) == "@bob"
                }
            }
        }
    }
}
