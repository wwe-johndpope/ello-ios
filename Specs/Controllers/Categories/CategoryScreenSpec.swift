////
///  CategoryScreenSpec.swift
//

@testable import Ello
import Quick
import Nimble


class CategoryScreenSpec: QuickSpec {

    override func spec() {
        // we have nothing unique in this screen yet,
        xdescribe("CategoryScreen") {
            var subject: CategoryScreen!
            beforeEach {
                subject = CategoryScreen()
            }

            xdescribe("snapshots") {
            }
        }
    }
}
