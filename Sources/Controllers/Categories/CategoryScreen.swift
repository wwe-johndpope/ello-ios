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

    override func setText() {
        super.setText()
        searchField.placeholder = InterfaceString.Search.Prompt
    }

    override func bindActions() {
        super.bindActions()
        categoryCardList.delegate = self
        searchFieldButton.addTarget(self, action: #selector(searchFieldButtonTapped), for: .touchUpInside)
        gridListButton.addTarget(self, action: #selector(gridListToggled), for: .touchUpInside)
    }

    override func arrange() {
        super.arrange()
        addSubview(categoryCardList)
        addSubview(navigationBar)

        navigationBar.addSubview(searchField)
        navigationBar.addSubview(searchFieldButton)
        navigationBar.addSubview(gridListButton)

        categoryCardList.isHidden = true

        categoryCardList.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(CategoryCardListView.Size.height)
        }

        searchField.snp.makeConstraints { make in
            var insets = SearchNavBarField.Size.searchInsets
            insets.bottom -= 1
            make.leading.bottom.top.equalTo(navigationBar).inset(insets)
            make.trailing.equalTo(gridListButton.snp.leading).offset(-insets.right)
        }
        searchFieldButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(navigationBar)
            make.top.equalTo(navigationBar).offset(BlackBar.Size.height)
            make.trailing.equalTo(gridListButton.snp.leading)
        }
        gridListButton.snp.makeConstraints { make in
            make.top.equalTo(navigationBar).offset(BlackBar.Size.height)
            make.bottom.equalTo(navigationBar)
            make.trailing.equalTo(navigationBar).offset(-Size.buttonMargin)
            make.width.equalTo(Size.buttonWidth)
        }

        navigationBar.snp.makeConstraints { make in
            // make.height.equalTo(80).priority(Priority.required)
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
}

extension CategoryScreen: CategoryCardListDelegate {
    func categoryCardSelected(_ index: Int) {
        delegate?.categorySelected(index: index)
    }
}
