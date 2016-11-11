////
///  CategoryViewControllerSpec.swift
//

import Ello
import Quick
import Nimble


class CategoryViewControllerSpec: QuickSpec {

    override func spec() {
        describe("CategoryViewController") {
            let currentUser: User = stub([:])
            var subject: CategoryViewController!

            beforeEach {
                let category: Ello.Category = Ello.Category.stub([:])
                subject = CategoryViewController(slug: category.slug)
                subject.currentUser = currentUser
                showController(subject)
            }

            it("has a search button in the nav bar") {
                let rightButtons = subject.elloNavigationItem.rightBarButtonItems
                expect(rightButtons!.count) == 1
            }
        }
    }
}
