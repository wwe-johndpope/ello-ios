////
///  AppScreenSpec.swift
//

@testable import Ello
import Quick
import Nimble


class AppScreenSpec: QuickSpec {
    override func spec() {
        describe("AppScreen") {
            describe("snapshots") {
                validateAllSnapshots(named: "AppScreen") { return AppScreen() }
            }
        }
    }
}
