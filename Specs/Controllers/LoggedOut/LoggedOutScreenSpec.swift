////
///  LoggedOutScreenSpec.swift
//

@testable import Ello
import Quick
import Nimble


class LoggedOutScreenSpec: QuickSpec {
    override func spec() {
        describe("LoggedOutScreen") {
            describe("snapshots") {
                validateAllSnapshots() {
                    let screen = LoggedOutScreen()
                    return screen
                }
            }
        }
    }
}
