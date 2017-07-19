////
///  EditorialsScreenSpec.swift
//

@testable import Ello
import Quick
import Nimble


class EditorialsScreenSpec: QuickSpec {
    override func spec() {
        describe("EditorialsScreen") {
            var subject: EditorialsScreen!

            describe("snapshots") {
                describe("snapshots logged in") {
                    beforeEach {
                        subject = EditorialsScreen(usage: .loggedIn)
                    }
                    validateAllSnapshots(named: "EditorialsScreen LoggedIn") { return subject }
                }

                describe("snapshots logged out") {
                    beforeEach {
                        subject = EditorialsScreen(usage: .loggedOut)
                    }
                    validateAllSnapshots(named: "EditorialsScreen LoggedOut") { return subject }
                }
            }
        }
    }
}
