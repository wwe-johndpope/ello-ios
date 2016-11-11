////
///  CategoryListCellSpec.swift
//

@testable import Ello
import Quick
import Nimble
import Nimble_Snapshots


class CategoryListCellSpec: QuickSpec {
    class Delegate: CategoryListCellDelegate {
        var categoryTapped = false
        var slug: String?

        func categoryListCellTapped(slug slug: String) {
            categoryTapped = true
            self.slug = slug
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
                subject.delegate = delegate
                showView(subject)
            }

            describe("actions") {
                it("sends action when tapping on a category") {
                    subject.categoriesInfo = [
                        (title: "Featured", slug: "featured"),
                        (title: "Trending", slug: "trending"),
                        (title: "Recent", slug: "recent"),
                    ]
                    let categoryButton: UIButton? = subviewThatMatches(subject) { view in
                        (view as? UIButton)?.currentAttributedTitle?.string == "Featured"
                    }
                    categoryButton?.sendActionsForControlEvents(.TouchUpInside)
                    expect(delegate.categoryTapped) == true
                    expect(delegate.slug) == "featured"
                }
            }

            it("displays categories") {
                subject.categoriesInfo = [
                    (title: "Featured", slug: "featured"),
                    (title: "Trending", slug: "trending"),
                    (title: "Recent", slug: "recent"),
                ]
                subject.layoutIfNeeded()
                expect(subject).to(haveValidSnapshot())
            }
        }
    }
}
