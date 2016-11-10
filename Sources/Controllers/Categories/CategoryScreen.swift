////
///  CategoryScreen.swift
//

import SnapKit


public class CategoryScreen: StreamableScreen, CategoryScreenProtocol {
    weak var delegate: CategoryScreenDelegate?

    private let categoryCardList = CategoryCardListView()

    public var topInsetView: UIView {
        if categoryCardList.hidden {
            return navigationBar
        }
        else {
            return categoryCardList
        }
    }

    public var navBarsVisible: Bool? {
        if !categoryCardList.hidden {
            return true
        }
        return nil
    }

    override func bindActions() {
        super.bindActions()
        categoryCardList.delegate = self
    }

    override func arrange() {
        super.arrange()
        addSubview(categoryCardList)
        addSubview(navigationBar)
        categoryCardList.hidden = true

        categoryCardList.snp_makeConstraints { make in
            make.top.equalTo(navigationBar.snp_bottom)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(CategoryCardListView.Size.height)
        }
    }

    public func setCategoriesInfo(newValue: [CategoryCardListView.CategoryInfo], animated: Bool) {
        categoryCardList.hidden = newValue.isEmpty
        categoryCardList.categoriesInfo = newValue

        if !categoryCardList.hidden && animated {
            let originalY = categoryCardList.frame.origin.y
            categoryCardList.frame.origin.y = -categoryCardList.frame.size.height
            animate {
                self.categoryCardList.frame.origin.y = originalY
            }
        }
    }

    public func animateCategoriesList(navBarVisible navBarVisible: Bool) {
        animate {
            if navBarVisible {
                self.categoryCardList.frame.origin.y = self.navigationBar.frame.height
            }
            else {
                self.categoryCardList.frame.origin.y = 0
            }
        }
    }

    public func scrollToCategoryIndex(index: Int) {
        self.categoryCardList.scrollToIndex(index, animated: false)
    }
}

extension CategoryScreen: CategoryCardListDelegate {
    public func categoryCardSelected(index: Int) {
        delegate?.categorySelected(index)
    }
}
