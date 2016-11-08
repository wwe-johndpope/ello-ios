////
///  CategoryScreenSpec.swift
//

@testable import Ello
import Quick
import Nimble


class CategoryScreenSpec: QuickSpec {

    override func spec() {
        describe("CategoryScreen") {
            var subject: CategoryScreen!
            beforeEach {
                subject = CategoryScreen()
            }

            describe("snapshots") {
                validateAllSnapshots { return subject }
            }
        }
    }
}
