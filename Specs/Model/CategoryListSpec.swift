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
                let c1 = Category(id: "1", name: "Featured", slug: "featured", order: 0, level: .Primary, tileImage: nil)
                let c2 = Category(id: "2", name: "Art", slug: "art", order: 1, level: .Primary, tileImage: nil)

                let categoryList = CategoryList(categories: [c2, c1])
                expect(categoryList.categories) == [c1, c2]
            }
        }
    }
}
