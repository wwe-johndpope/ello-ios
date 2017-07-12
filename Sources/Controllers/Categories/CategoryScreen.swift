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

    enum NavBarItems {
        case onlyGridToggle
        case all
        case none
    }

    fileprivate let categoryCardList = CategoryCardListView()
    fileprivate let searchField = SearchNavBarField()
    fileprivate let searchFieldButton = UIButton()
    fileprivate let backButton = UIButton()
    fileprivate let gridListButton = UIButton()
    fileprivate let shareButton = UIButton()
    fileprivate let navigationContainer = UIView()
    fileprivate var backVisibleConstraint: Constraint!
    fileprivate var backHiddenConstraint: Constraint!
    fileprivate var shareVisibleConstraint: Constraint!
    fileprivate var shareHiddenConstraint: Constraint!
    fileprivate var allHiddenConstraint: Constraint!

    var topInsetView: UIView {
        if categoryCardsVisible {
            return categoryCardList
        }
        else {
            return navigationBar
        }
    }

    fileprivate var _categoryCardsVisible: Bool = true
    var categoryCardsVisible: Bool {
        set {
            _categoryCardsVisible = newValue
            categoryCardList.isHidden = !categoryCardsVisible
        }
        get { return _categoryCardsVisible && categoryCardList.categoriesInfo.count > 0 }
    }

    override func style() {
        super.style()
        backButton.setImages(.angleBracket, degree: 180)
        shareButton.alpha = 0
        shareButton.setImage(.share, imageStyle: .normal, for: .normal)
    }

    override func bindActions() {
        super.bindActions()
        categoryCardList.delegate = self
        searchFieldButton.addTarget(self, action: #selector(searchFieldButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
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
        navigationBar.addSubview(backButton)
        navigationBar.addSubview(gridListButton)
        navigationBar.addSubview(shareButton)

        categoryCardList.isHidden = true

        categoryCardList.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(CategoryCardListView.Size.height)
        }

        backButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(navigationBar)
            make.top.equalTo(navigationBar).offset(BlackBar.Size.height)
            make.width.equalTo(36.5)
        }

        navigationContainer.snp.makeConstraints { make in
            make.leading.bottom.equalTo(navigationBar)
            make.top.equalTo(navigationBar).offset(BlackBar.Size.height)
            make.trailing.equalTo(gridListButton.snp.leading)
        }

        searchField.snp.makeConstraints { make in
            var insets = SearchNavBarField.Size.searchInsets
            insets.bottom -= 1
            make.bottom.top.equalTo(navigationBar).inset(insets)

            backHiddenConstraint = make.leading.equalTo(navigationBar).inset(insets).constraint
            backVisibleConstraint = make.leading.equalTo(backButton.snp.trailing).offset(insets.left).constraint

            shareHiddenConstraint = make.trailing.equalTo(gridListButton.snp.leading).offset(-insets.right).constraint
            shareVisibleConstraint = make.trailing.equalTo(shareButton.snp.leading).offset(-Size.buttonMargin).constraint
            allHiddenConstraint = make.trailing.equalTo(gridListButton.snp.trailing).offset(-Size.buttonMargin).constraint
        }
        shareVisibleConstraint.deactivate()
        allHiddenConstraint.deactivate()

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

    func set(categoriesInfo newValue: [CategoryCardListView.CategoryInfo], animated: Bool, completion: @escaping Block) {
        categoryCardList.categoriesInfo = newValue
        categoryCardList.isHidden = !categoryCardsVisible

        if categoryCardsVisible && animated {
            showCategoryCardList(completion: completion)
        }
        else {
            completion()
        }
    }

    fileprivate func showCategoryCardList(completion: @escaping Block = {}) {
        let originalY = categoryCardList.frame.origin.y
        categoryCardList.frame.origin.y = -categoryCardList.frame.size.height
        animate(completion: { _ in completion() }) {
            self.categoryCardList.frame.origin.y = originalY
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
        self.categoryCardList.scrollToIndex(index + 1, animated: true)
    }

    func selectCategory(index: Int) {
        self.categoryCardList.selectCategory(index: index + 1)
    }

    func searchFieldButtonTapped() {
        delegate?.searchButtonTapped()
    }

    func backTapped() {
        delegate?.backTapped()
    }

    func gridListToggled() {
        delegate?.gridListToggled(sender: gridListButton)
    }

    func shareTapped() {
        delegate?.shareTapped(sender: shareButton)
    }

    func setupNavBar(show: CategoryScreen.NavBarItems, back backVisible: Bool, animated: Bool) {
        let shareButtonAlpha: CGFloat
        let gridButtonAlpha: CGFloat
        switch show {
        case .onlyGridToggle:
            shareHiddenConstraint.activate()
            shareVisibleConstraint.deactivate()
            allHiddenConstraint.deactivate()
            shareButtonAlpha = 0
            gridButtonAlpha = 1
        case .all:
            shareHiddenConstraint.deactivate()
            shareVisibleConstraint.activate()
            allHiddenConstraint.deactivate()
            shareButtonAlpha = 1
            gridButtonAlpha = 1
        case .none:
            shareHiddenConstraint.deactivate()
            shareVisibleConstraint.deactivate()
            allHiddenConstraint.activate()
            shareButtonAlpha = 0
            gridButtonAlpha = 0
        }

        backButton.isHidden = !backVisible
        if backVisible {
            backHiddenConstraint.deactivate()
            backVisibleConstraint.activate()
        }
        else {
            backHiddenConstraint.activate()
            backVisibleConstraint.deactivate()
        }

        animate(animated: animated) {
            self.navigationBar.layoutIfNeeded()
            self.shareButton.alpha = shareButtonAlpha
            self.gridListButton.alpha = gridButtonAlpha
        }
    }

}

extension CategoryScreen: CategoryCardListDelegate {
    func allCategoriesTapped() {
        delegate?.allCategoriesTapped()
    }

    func categoryCardSelected(_ index: Int) {
        delegate?.categorySelected(index: index)
    }
}
