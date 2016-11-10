////
///  CategoryCardListView.swift
//

public class CategoryCardListView: UIView {
    weak var discoverCategoryPickerDelegate: DiscoverCategoryPickerDelegate?

    struct Size {
        static let height: CGFloat = 70
        static let cardSize: CGSize = CGSize(width: 100, height: 68)
        static let spacing: CGFloat = 1
    }

    public struct CategoryInfo {
        let title: String
        let imageURL: NSURL?
        let endpoint: ElloAPI
        let selected: Bool
    }

    public var categoriesInfo: [CategoryInfo] = [] {
        didSet {
            let changed: Bool = (categoriesInfo.count != oldValue.count) || oldValue.enumerate().any { (index, info) in
                return info.title != categoriesInfo[index].title || info.selected != categoriesInfo[index].selected || info.endpoint.path != categoriesInfo[index].endpoint.path
            }
            if changed {
                updateCategoryViews()
            }
        }
    }

    private var buttonEndpointLookup: [UIButton: ElloAPI] = [:]
    private var categoryViews: [UIView] = []
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
        guard let endpoint = buttonEndpointLookup[button] else { return }
        discoverCategoryPickerDelegate?.discoverCategoryTapped(endpoint)
    }

    @objc
    func allButtonTapped() {
        discoverCategoryPickerDelegate?.discoverAllCategoriesTapped()
    }

    public func scrollToIndex(index: Int, animated: Bool) {
        guard let view = categoryViews.safeValue(index) else { return }

        let x = max(min(view.frame.minX, scrollView.contentSize.width - frame.width), 0)
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: animated)
    }

    private func updateCategoryViews() {
        for view in categoryViews {
            view.removeFromSuperview()
        }

        buttonEndpointLookup = [:]
        categoryViews = categoriesInfo.map { info in
            let view = UIView()
            view.backgroundColor = .blackColor()

            if let url = info.imageURL {
                let image = UIImageView()
                image.pin_setImageFromURL(url)
                view.addSubview(image)
                image.snp_makeConstraints { $0.edges.equalTo(view) }
            }

            let overlay = UIView()
            overlay.backgroundColor = .blackColor()
            overlay.alpha = 0.6
            view.addSubview(overlay)
            overlay.snp_makeConstraints { $0.edges.equalTo(view) }

            let button = UIButton()
            button.titleLabel?.numberOfLines = 0
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), forControlEvents: .TouchUpInside)
            let attributedString = NSAttributedString(info.title, color: .whiteColor(), alignment: .Center)
            button.setAttributedTitle(attributedString, forState: UIControlState.Normal)
            view.addSubview(button)
            button.snp_makeConstraints { $0.edges.equalTo(view).inset(5) }

            buttonEndpointLookup[button] = info.endpoint
            return view
        }

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

        layoutIfNeeded()
    }

}
