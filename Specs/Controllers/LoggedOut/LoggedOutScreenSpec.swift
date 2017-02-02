////
///  LoggedOutScreenSpec.swift
//

@testable import Ello
import Quick
import Nimble


class LoggedOutScreenSpec: QuickSpec {
    override func spec() {
        describe("LoggedOutScreen") {
            describe("default snapshots") {
                validateAllSnapshots() {
                    let screen = LoggedOutScreen()
                    return screen
                }
            }
            describe("expanded text") {
                validateAllSnapshots() {
                    let screen = LoggedOutScreen()
                    screen.showJoinText()
                    return screen
                }
            }
        }
    }
}
