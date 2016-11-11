////
///  CategoryListCellSpec.swift
//

@testable import Ello
import Quick
import Nimble
import Nimble_Snapshots


class CategoryListCellSpec: QuickSpec {
    class Delegate: DiscoverCategoryPickerDelegate {
        var categoryTapped = false
        var endpointPath: String?

        func discoverCategoryTapped(endpoint: ElloAPI) {
            categoryTapped = true
            endpointPath = endpoint.path
        }
    }

    override func spec() {
        describe("CategoryListCell") {
            var subject: CategoryListCell!
            var delegate: Delegate!

            beforeEach {
                delegate = Delegate()
                let frame = CGRect(origin: .zero, size: CGSize(width: 320, height: CategoryListCell.Size.height))
                subject = CategoryListCell(frame: frame)
                subject.discoverCategoryPickerDelegate = delegate
                showView(subject)
            }

            describe("actions") {
                it("sends action when tapping on a category") {
                    subject.categoriesInfo = [
                        (title: "Featured", endpoint: .CategoryPosts(slug: "featured")),
                        (title: "Trending", endpoint: .CategoryPosts(slug: "trending")),
                        (title: "Recent", endpoint: .CategoryPosts(slug: "recent")),
                    ]
                    let categoryButton: UIButton? = subviewThatMatches(subject) { view in
                        (view as? UIButton)?.currentAttributedTitle?.string == "Featured"
                    }
                    categoryButton?.sendActionsForControlEvents(.TouchUpInside)
                    expect(delegate.categoryTapped) == true
                    expect(delegate.endpointPath) == ElloAPI.CategoryPosts(slug: "featured").path
                }
            }

            it("displays categories") {
                subject.categoriesInfo = [
                    (title: "Featured", endpoint: .CategoryPosts(slug: "featured")),
                    (title: "Trending", endpoint: .CategoryPosts(slug: "trending")),
                    (title: "Recent", endpoint: .CategoryPosts(slug: "recent")),
                ]
                subject.layoutIfNeeded()
                expect(subject).to(haveValidSnapshot())
            }
        }
    }
}
