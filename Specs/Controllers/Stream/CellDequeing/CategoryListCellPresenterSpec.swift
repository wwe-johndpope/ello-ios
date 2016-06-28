//
//  CategoryListCellPresenterSpec.swift
//  Ello
//
//  Created by Colin Gray on 6/24/2016.
//  Copyright (c) 2016 Ello. All rights reserved.
//

@testable import Ello
import Quick
import Nimble


class CategoryListCellPresenterSpec: QuickSpec {
    override func spec() {
        describe("CategoryListCellPresenter") {
            it("sets the categoriesInfo on a cell") {
                let categoryList: CategoryList = CategoryList(categories: [
                    stub(["name": "Featured", "level": "meta", "slug": "recommended"]) as Ello.Category,
                    stub(["name": "Art", "level": "primary", "slug": "art"]) as Ello.Category,
                    ])
                let cell: CategoryListCell = CategoryListCell()
                let item: StreamCellItem = StreamCellItem(jsonable: categoryList, type: .Category)

                CategoryListCellPresenter.configure(cell, streamCellItem: item, streamKind: .CategoryPosts(slug: "art"), indexPath: NSIndexPath(forItem: 0, inSection: 0), currentUser: nil)

                expect(cell.categoriesInfo.count) == categoryList.categories.count

                expect(cell.categoriesInfo[0].title) == categoryList.categories[0].name
                expect(cell.categoriesInfo[0].endpoint.path) == ElloAPI.Discover(type: .Featured).path
                expect(cell.categoriesInfo[0].selected) == false

                expect(cell.categoriesInfo[1].title) == categoryList.categories[1].name
                expect(cell.categoriesInfo[1].endpoint.path) == ElloAPI.CategoryPosts(slug: "art").path
                expect(cell.categoriesInfo[1].selected) == true
            }
        }
    }
}
