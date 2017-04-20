////
///  CategoryScreen.swift
//

import SnapKit


class CategoryScreen: StreamableScreen, CategoryScreenProtocol {
    struct Size {
        static let navigationBarHeight: CGFloat = 63
        static let buttonWidth: CGFloat = 40
        static let buttonMargin: CGFloat = 5
    }

    weak var delegate: CategoryScreenDelegate?

    var isGridView = false {
        didSet {
            gridListButton.setImage(isGridView ? .listView : .gridView, imageStyle: .normal, for: .normal)
        }
    }

    fileprivate let categoryCardList = CategoryCardListView()
    fileprivate let searchField = SearchNavBarField()
    fileprivate let searchFieldButton = UIButton()
    fileprivate let gridListButton = UIButton()
    fileprivate let shareButton = UIButton()
    fileprivate let navigationContainer = UIView()
    fileprivate var shareVisibleConstraint: Constraint!
    fileprivate var shareHiddenConstraint: Constraint!

    var topInsetView: UIView {
        if categoryCardList.isHidden {
            return navigationBar
        }
        else {
            return categoryCardList
        }
    }

    var categoryCardsVisible: Bool {
        return !categoryCardList.isHidden
    }

    override func style() {
        super.style()
        shareButton.alpha = 0
        shareButton.setImage(.share, imageStyle: .normal, for: .normal)
    }

    override func bindActions() {
        super.bindActions()
        categoryCardList.delegate = self
        searchFieldButton.addTarget(self, action: #selector(searchFieldButtonTapped), for: .touchUpInside)
        gridListButton.addTarget(self, action: #selector(gridListToggled), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
    }

    override func arrange() {
        super.arrange()
        addSubview(categoryCardList)
        addSubview(navigationBar)

        navigationContainer.addSubview(searchField)
        navigationContainer.addSubview(searchFieldButton)
        navigationBar.addSubview(navigationContainer)
        navigationBar.addSubview(gridListButton)
        navigationBar.addSubview(shareButton)

        categoryCardList.isHidden = true

        categoryCardList.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(CategoryCardListView.Size.height)
        }

        navigationContainer.snp.makeConstraints { make in
            make.leading.bottom.equalTo(navigationBar)
            make.top.equalTo(navigationBar).offset(BlackBar.Size.height)
            make.trailing.equalTo(gridListButton.snp.leading)
        }

        searchField.snp.makeConstraints { make in
            var insets = SearchNavBarField.Size.searchInsets
            insets.bottom -= 1
            make.leading.bottom.top.equalTo(navigationBar).inset(insets)
            shareHiddenConstraint = make.trailing.equalTo(gridListButton.snp.leading).offset(-insets.right).constraint
            shareVisibleConstraint = make.trailing.equalTo(shareButton.snp.leading).offset(-Size.buttonMargin).constraint
        }
        shareVisibleConstraint.deactivate()

        searchFieldButton.snp.makeConstraints { make in
            make.edges.equalTo(navigationContainer)
        }
        gridListButton.snp.makeConstraints { make in
            make.top.equalTo(navigationBar).offset(BlackBar.Size.height)
            make.bottom.equalTo(navigationBar)
            make.trailing.equalTo(navigationBar).offset(-Size.buttonMargin)
            make.width.equalTo(Size.buttonWidth)
        }
        shareButton.snp.makeConstraints { make in
            make.top.bottom.width.equalTo(gridListButton)
            make.trailing.equalTo(gridListButton.snp.leading)
        }

        navigationBar.snp.makeConstraints { make in
            make.height.equalTo(Size.navigationBarHeight).priority(Priority.required)
        }
    }

    func set(categoriesInfo newValue: [CategoryCardListView.CategoryInfo], animated: Bool, completion: @escaping ElloEmptyCompletion) {
        categoryCardList.isHidden = newValue.isEmpty
        categoryCardList.categoriesInfo = newValue

        if !categoryCardList.isHidden && animated {
            let originalY = categoryCardList.frame.origin.y
            categoryCardList.frame.origin.y = -categoryCardList.frame.size.height
            animate(completion: { _ in completion() }) {
                self.categoryCardList.frame.origin.y = originalY
            }
        }
        else {
            completion()
        }
    }

    func animateCategoriesList(navBarVisible: Bool) {
        animate {
            if navBarVisible {
                self.categoryCardList.frame.origin.y = self.navigationBar.frame.height
            }
            else {
                self.categoryCardList.frame.origin.y = 0
            }
        }
    }

    func scrollToCategory(index: Int) {
        self.categoryCardList.scrollToIndex(index, animated: true)
    }

    func selectCategory(index: Int) {
        self.categoryCardList.selectCategoryIndex(index)
    }

    func searchFieldButtonTapped() {
        delegate?.searchButtonTapped()
    }

    func gridListToggled() {
        delegate?.gridListToggled(sender: gridListButton)
    }

    func shareTapped() {
        delegate?.shareTapped(sender: shareButton)
    }

    func animateNavBar(showShare: Bool) {
        if showShare {
            shareHiddenConstraint.deactivate()
            shareVisibleConstraint.activate()
        }
        else {
            shareHiddenConstraint.activate()
            shareVisibleConstraint.deactivate()
        }

        animate {
            self.navigationBar.layoutIfNeeded()
            self.shareButton.alpha = showShare ? 1 : 0
        }
    }

}

extension CategoryScreen: CategoryCardListDelegate {
    func categoryCardSelected(_ index: Int) {
        delegate?.categorySelected(index: index)
    }
}
