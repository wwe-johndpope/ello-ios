////
///  CategoryCardListView.swift
//

public protocol CategoryCardListDelegate: class {
    func categoryCardSelected(index: Int)
}

public class CategoryCardListView: UIView {
    weak var delegate: CategoryCardListDelegate?

    public struct CategoryInfo {
        let title: String
        let imageURL: NSURL?
    }

    struct Size {
        static let height: CGFloat = 70
        static let cardSize: CGSize = CGSize(width: 100, height: 68)
        static let spacing: CGFloat = 1
    }

    public var categoriesInfo: [CategoryInfo] = [] {
        didSet {
            let changed: Bool = (categoriesInfo.count != oldValue.count) || oldValue.enumerate().any { (index, info) in
                return info.title != categoriesInfo[index].title
            }
            if changed {
                updateCategoryViews()
            }
        }
    }

    private var buttonIndexLookup: [UIButton: Int] = [:]
    private var categoryViews: [CategoryCardView] = []
    private var scrollView = UIScrollView()

    override public init(frame: CGRect) {
        super.init(frame: frame)

        style()
        bindActions()
        arrange()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func style() {
        backgroundColor = .whiteColor()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }

    private func bindActions() {
    }

    private func arrange() {
        self.addSubview(scrollView)

        scrollView.snp_makeConstraints { make in
            make.edges.equalTo(self)
        }
    }

    @objc
    func categoryButtonTapped(button: UIButton) {
        guard let index = buttonIndexLookup[button] else { return }
        delegate?.categoryCardSelected(index)
    }

    public func scrollToIndex(index: Int, animated: Bool) {
        guard let view = categoryViews.safeValue(index) else { return }

        let x = max(min(view.frame.minX, scrollView.contentSize.width - frame.width), 0)
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: animated)
    }

    public func selectCategoryIndex(index: Int) {
        guard let view = categoryViews.safeValue(index) else { return }
        for card in categoryViews {
            card.selected = false
        }

        view.selected = true
    }

    private func updateCategoryViews() {
        for view in categoryViews {
            view.removeFromSuperview()
        }

        buttonIndexLookup = [:]

        categoryViews = categoriesInfo.enumerate().map { (index, info) in
            return categoryView(index: index, info: info)
        }
        arrangeCategoryViews()

        layoutIfNeeded()
    }

    private func categoryView(index index: Int, info: CategoryInfo) -> CategoryCardView {
        let card = CategoryCardView(frame: .zero, info: info)
        card.button.addTarget(self, action: #selector(categoryButtonTapped(_:)), forControlEvents: .TouchUpInside)
        buttonIndexLookup[card.button] = index
        return card
    }

    private func arrangeCategoryViews() {
        var prevView: UIView? = nil
        for view in categoryViews {
            scrollView.addSubview(view)

            view.snp_makeConstraints { make in
                make.size.equalTo(Size.cardSize)
                make.centerY.equalTo(scrollView)

                if let prevView = prevView {
                    make.leading.equalTo(prevView.snp_trailing).offset(Size.spacing)
                }
                else {
                    make.leading.equalTo(scrollView.snp_leading)
                }
            }

            prevView = view
        }

        if let prevView = prevView {
            prevView.snp_makeConstraints { make in
                make.trailing.equalTo(scrollView.snp_trailing)
            }
        }
    }
}
