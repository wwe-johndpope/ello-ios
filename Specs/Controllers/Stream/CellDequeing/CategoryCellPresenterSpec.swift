////
///  CategoryCellPresenterSpec.swift
//

@testable import Ello
import Quick
import Nimble


class CategoryCellPresenterSpec: QuickSpec {
    override func spec() {
        describe("CategoryCellPresenter") {
            it("configures a CategoryCell for Primary category") {
                let category: Ello.Category = stub(["name": "Art", "level": "primary"]) as Ello.Category
                let cell: CategoryCell = CategoryCell()
                let item: StreamCellItem = StreamCellItem(jsonable: category, type: .Category)

                CategoryCellPresenter.configure(cell, streamCellItem: item, streamKind: .CurrentUserStream, indexPath: NSIndexPath(forItem: 0, inSection: 0), currentUser: nil)

                expect(cell.title) == "Art"
                expect(cell.highlight) == CategoryCell.Highlight.White
            }

            it("configures a CategoryCell for Meta category") {
                let category: Ello.Category = stub(["name": "Featured", "level": "meta"])
                let cell: CategoryCell = CategoryCell()
                let item: StreamCellItem = StreamCellItem(jsonable: category, type: .Category)

                CategoryCellPresenter.configure(cell, streamCellItem: item, streamKind: .CurrentUserStream, indexPath: NSIndexPath(forItem: 0, inSection: 0), currentUser: nil)

                expect(cell.title) == "Featured"
                expect(cell.highlight) == CategoryCell.Highlight.Gray
            }
        }
    }
}
