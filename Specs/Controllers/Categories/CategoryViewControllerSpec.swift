////
///  CategoryViewControllerSpec.swift
//

@testable import Ello
import Quick
import Nimble
import Nimble_Snapshots


class CategoryViewControllerSpec: QuickSpec {
    class MockCategoryScreen: CategoryScreenProtocol {
        let topInsetView = UIView()
        let streamContainer = UIView()
        var categoryCardsVisible = true
        var isGridView = true
        var navigationBarTopConstraint: NSLayoutConstraint!
        let navigationBar = ElloNavigationBar()
        var navigationItem: UINavigationItem?
        var categoryTitles: [String] = []
        var scrollTo: Int?
        var select: Int?
        var showShare = false

        func set(categoriesInfo: [CategoryCardListView.CategoryInfo], animated: Bool, completion: @escaping ElloEmptyCompletion) {
            categoryTitles = categoriesInfo.map { $0.title }
        }
        func animateCategoriesList(navBarVisible: Bool) {}
        func scrollToCategory(index: Int) {
            scrollTo = index
        }

        func selectCategory(index: Int) {
            select = index
        }

        func viewForStream() -> UIView {
            return streamContainer
        }

        func animateNavBar(showShare: Bool) {
            self.showShare = showShare
        }
    }

    override func spec() {
        describe("CategoryViewController") {
            let currentUser: User = stub([:])
            var subject: CategoryViewController!
            var screen: MockCategoryScreen!

            beforeEach {
                let category: Ello.Category = Ello.Category.stub([:])
                subject = CategoryViewController(slug: category.slug)
                screen = MockCategoryScreen()
                subject.currentUser = currentUser
                subject.mockScreen = screen
                showController(subject)
            }

            it("has a nice looking nav bar") {
                expect(subject).to(haveValidSnapshot())
            }

            context("setCategories(_:)") {
                it("accepts meta categories") {
                    subject.set(categories: [
                        Category.featured,
                        Category.stub(["name": "Art"])
                        ])
                    expect(screen.categoryTitles) == ["Featured", "Art"]
                }
            }
        }
    }
}
