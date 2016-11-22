////
///  CategoryListSpec.swift
//

@testable import Ello
import Quick
import Nimble


class CategoryListSpec: QuickSpec {
    override func spec() {
        describe("CategoryList") {
            it("sorts categories") {
                let c1 = Category.stub(["name": "Featured", "order": 0])
                let c2 = Category.stub(["name": "Art", "order": 1])

                let categoryList = CategoryList(categories: [c2, c1])
                expect(categoryList.categories) == [c1, c2]
            }
        }
    }
}
