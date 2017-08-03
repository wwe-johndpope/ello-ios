////
///  CategoryCardListView.swift
//

protocol CategoryCardListDelegate: class {
    func allCategoriesTapped()
    func categoryCardSelected(_ index: Int)
}

class CategoryCardListView: View {
    weak var delegate: CategoryCardListDelegate?

    struct CategoryInfo {
        let title: String
        let imageURL: URL?
    }

    struct Size {
        static let height: CGFloat = 70
        static let smallCardSize: CGSize = CGSize(width: 50, height: 68)
        static let cardSize: CGSize = CGSize(width: 100, height: 68)
        static let spacing: CGFloat = 1
    }

    var categoriesInfo: [CategoryInfo] = [] {
        didSet {
            let changed: Bool = (categoriesInfo.count != oldValue.count) || oldValue.enumerated().any { (index, info) in
                return info.title != categoriesInfo[index].title
            }
            if changed {
                updateCategoryViews()
            }
        }
    }

    fileprivate var buttonIndexLookup: [UIButton: Int] = [:]
    fileprivate var categoryViews: [CategoryCardView] = []
    fileprivate var scrollView = UIScrollView()

    override func style() {
        backgroundColor = .white
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
    }

    override func arrange() {
        self.addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }

    @objc
    func allCategoriesTapped() {
        delegate?.allCategoriesTapped()
    }

    @objc
    func categoryButtonTapped(_ button: UIButton) {
        guard let index = buttonIndexLookup[button] else { return }
        delegate?.categoryCardSelected(index)
    }

    func scrollToIndex(_ index: Int, animated: Bool) {
        guard let view = categoryViews.safeValue(index) else { return }

        let left = view.frame.minX
        let right = view.frame.maxX - frame.width
        if scrollView.contentOffset.x > left {
            scrollView.setContentOffset(CGPoint(x: left, y: 0), animated: animated)
        }
        else if scrollView.contentOffset.x < right {
            scrollView.setContentOffset(CGPoint(x: right, y: 0), animated: animated)
        }
    }

    func selectCategory(index: Int) {
        guard let view = categoryViews.safeValue(index) else { return }
        for card in categoryViews where card != view {
            card.isSelected = false
        }

        view.isSelected = true
    }

    fileprivate func updateCategoryViews() {
        for view in categoryViews {
            view.removeFromSuperview()
        }

        buttonIndexLookup = [:]

        let allCategories = CategoryCardView(info: CategoryInfo(title: InterfaceString.Discover.AllCategories, imageURL: nil))
        allCategories.overlayAlpha = CategoryCardView.darkAlpha
        allCategories.snp.makeConstraints { make in
            make.size.equalTo(Size.smallCardSize)
        }
        allCategories.addTarget(self, action: #selector(allCategoriesTapped))

        categoryViews = [allCategories] + categoriesInfo.enumerated().map { (index, info) in
            let view = categoryView(index: index, info: info)
            view.snp.makeConstraints { make in
                make.size.equalTo(Size.cardSize)
            }
            return view
        }
        arrangeCategoryViews()

        layoutIfNeeded()
    }

    fileprivate func categoryView(index: Int, info: CategoryInfo) -> CategoryCardView {
        let card = CategoryCardView(info: info)
        card.addTarget(self, action: #selector(categoryButtonTapped(_:)))
        buttonIndexLookup[card.button] = index
        return card
    }

    fileprivate func arrangeCategoryViews() {
        var prevView: UIView? = nil
        for view in categoryViews {
            scrollView.addSubview(view)

            view.snp.makeConstraints { make in
                make.centerY.equalTo(scrollView)

                if let prevView = prevView {
                    make.leading.equalTo(prevView.snp.trailing).offset(Size.spacing)
                }
                else {
                    make.leading.equalTo(scrollView.snp.leading)
                }
            }

            prevView = view
        }

        if let prevView = prevView {
            prevView.snp.makeConstraints { make in
                make.trailing.equalTo(scrollView.snp.trailing)
            }
        }
    }
}
