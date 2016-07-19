////
///  CategoryCardCellPresenterSpec.swift
//

@testable import Ello
import Quick
import Nimble


class CategoryCardCellPresenterSpec: QuickSpec {
    override func spec() {
        describe("CategoryCardCellPresenter") {
            it("sets the card title") {
                let category: Ello.Category = stub(["name": "Art"]) as Ello.Category
                let cell: CategoryCardCell = CategoryCardCell()
                let item: StreamCellItem = StreamCellItem(jsonable: category, type: .Category)

                CategoryCardCellPresenter.configure(cell, streamCellItem: item, streamKind: .CategoryPosts(slug: "art"), indexPath: NSIndexPath(forItem: 0, inSection: 0), currentUser: nil)

                expect(cell.title) == "Art"
            }
        }
    }
}
