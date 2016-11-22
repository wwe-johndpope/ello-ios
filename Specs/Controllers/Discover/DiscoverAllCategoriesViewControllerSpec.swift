////
///  DiscoverAllCategoriesViewControllerSpec.swift
//

@testable import Ello
import Quick
import Nimble


class DiscoverAllCategoriesViewControllerSpec: QuickSpec {
    override func spec() {
        describe("DiscoverAllCategoriesViewController") {
            var subject: DiscoverAllCategoriesViewController!
            let generator: StreamCellItemGenerator = { return [] }
            beforeEach {
                subject = DiscoverAllCategoriesViewController()
            }

            context("streamViewStreamCellItems") {
                it("supports category list without categories") {
                    let jsonables: [JSONAble] = [
                        Category.stub(["name": "Featured", "level": "meta"]),
                        Category.stub(["name": "Art", "level": "primary"]),
                    ]
                    let items: [StreamCellItem]? = subject.streamViewStreamCellItems(jsonables, defaultGenerator: generator)
                    expect(items?.count) == 2
                    expect(items?[0].type) == .CategoryList
                    expect(items?[1].type) == .CategoryCard
                }
                it("supports category list with meta categories") {
                    let items: [StreamCellItem]? = subject.streamViewStreamCellItems([
                        Category.stub(["name": "Art", "level": "primary"]),
                        ], defaultGenerator: generator)
                    expect(items?.count) == 2
                    expect(items?[0].type) == .CategoryList
                    expect(items?[1].type) == .CategoryCard
                }
                it("returns nothing for non-categories") {
                    let items: [StreamCellItem]? = subject.streamViewStreamCellItems([User.stub([:])], defaultGenerator: generator)
                    expect(items?.count) == 0
                }
            }
        }
    }
}
