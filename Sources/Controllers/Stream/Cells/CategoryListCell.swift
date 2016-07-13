////
///  CategoryListCell.swift
//

import SnapKit

public class CategoryListCell: UICollectionViewCell {
    static let reuseIdentifier = "CategoryListCell"
    weak var discoverCategoryPickerDelegate: DiscoverCategoryPickerDelegate?

    struct Size {
        static let sideMargins: CGFloat = 15
        static let spacing: CGFloat = 9
    }

    public typealias CategoryInfo = (title: String, endpoint: ElloAPI, selected: Bool)
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
    private var categoryButtons: [UIButton] = []
    private var gradientView = UIView()
    private var buttonViews = UIScrollView()
    private var gradientLayer = CAGradientLayer()
    private var allCategoriesButton = WhiteElloButton()

    private class func buttonTitle(category: String, selected: Bool) -> NSAttributedString {
        var attrs: [String: AnyObject] = [
            NSFontAttributeName: UIFont.defaultFont(),
        ]
        if selected {
            attrs[NSForegroundColorAttributeName] = UIColor.blackColor()
            attrs[NSUnderlineStyleAttributeName] = NSUnderlineStyle.StyleSingle.rawValue
        }
        else {
            attrs[NSForegroundColorAttributeName] = UIColor.greyA()
        }
        let attributedString = NSAttributedString(string: category, attributes: attrs)
        return attributedString
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        style()
        bindActions()
        arrange()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = gradientView.bounds
    }

    private func style() {
        backgroundColor = .whiteColor()
        allCategoriesButton.setTitle(InterfaceString.SeeAll, forState: .Normal)
        allCategoriesButton.backgroundColor = .whiteColor()

        gradientLayer.locations = [0, 1]
        gradientLayer.colors = [
            UIColor.whiteColor().CGColor,
            UIColor.whiteColor().colorWithAlphaComponent(0).CGColor,
        ]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        gradientView.layer.addSublayer(gradientLayer)
    }

    private func bindActions() {
        allCategoriesButton.addTarget(self, action: #selector(allButtonTapped), forControlEvents: .TouchUpInside)
    }

    private func arrange() {
        contentView.addSubview(buttonViews)
        contentView.addSubview(allCategoriesButton)
        contentView.addSubview(gradientView)

        allCategoriesButton.snp_makeConstraints { make in
            make.top.bottom.trailing.equalTo(contentView)
            make.width.equalTo(contentView.snp_height)
        }

        gradientView.snp_makeConstraints { make in
            make.trailing.equalTo(allCategoriesButton.snp_leading)
            make.top.bottom.equalTo(contentView)
            make.width.equalTo(30)
        }

        buttonViews.snp_makeConstraints { make in
            make.top.leading.bottom.equalTo(contentView)
            make.trailing.equalTo(gradientView.snp_trailing)
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

    private func updateCategoryViews() {
        for view in categoryButtons {
            view.removeFromSuperview()
        }
        buttonEndpointLookup = [:]

        categoryButtons = categoriesInfo.map { (category, endpoint, selected) in
            let button = UIButton()
            buttonEndpointLookup[button] = endpoint
            button.backgroundColor = .clearColor()
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), forControlEvents: .TouchUpInside)
            let attributedString = CategoryListCell.buttonTitle(category, selected: selected)
            button.setAttributedTitle(attributedString, forState: UIControlState.Normal)

            return button
        }

        var prevView: UIView? = nil
        for view in categoryButtons {
            buttonViews.addSubview(view)

            view.snp_makeConstraints { make in
                make.centerY.equalTo(buttonViews)

                if let prevView = prevView {
                    make.leading.equalTo(prevView.snp_trailing).offset(Size.spacing)
                }
                else {
                    make.leading.equalTo(buttonViews.snp_leading).offset(Size.sideMargins)
                }
            }

            prevView = view
        }

        if let prevView = prevView {
            prevView.snp_makeConstraints { make in
                make.trailing.equalTo(buttonViews.snp_trailing).offset(-Size.sideMargins)
            }
        }
        setNeedsLayout()
    }

}
