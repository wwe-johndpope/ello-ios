////
///  CategoryListCell.swift
//

import SnapKit

public class CategoryListCell: UICollectionViewCell {
    static let reuseIdentifier = "CategoryListCell"
    weak var discoverCategoryPickerDelegate: DiscoverCategoryPickerDelegate?

    struct Size {
        static let height: CGFloat = 45
        static let spacing: CGFloat = 1
    }

    public typealias CategoryInfo = (title: String, endpoint: ElloAPI)
    public var categoriesInfo: [CategoryInfo] = [] {
        didSet {
            let changed: Bool = (categoriesInfo.count != oldValue.count) || oldValue.enumerate().any { (index, info) in
                return info.title != categoriesInfo[index].title || info.endpoint.path != categoriesInfo[index].endpoint.path
            }
            if changed {
                updateCategoryViews()
            }
        }
    }

    private var buttonEndpointLookup: [UIButton: ElloAPI] = [:]
    private var categoryButtons: [UIButton] = []

    private class func buttonTitle(category: String) -> NSAttributedString {
        var attrs: [String: AnyObject] = [
            NSFontAttributeName: UIFont.defaultFont(),
            NSForegroundColorAttributeName: UIColor.blackColor()
        ]
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
    }

    private func style() {
        backgroundColor = .whiteColor()
    }

    private func bindActions() {
    }

    private func arrange() {
    }

    @objc
    func categoryButtonTapped(button: UIButton) {
        guard let endpoint = buttonEndpointLookup[button] else { return }
        discoverCategoryPickerDelegate?.discoverCategoryTapped(endpoint)
    }

    private func updateCategoryViews() {
        for view in categoryButtons {
            view.removeFromSuperview()
        }
        buttonEndpointLookup = [:]

        categoryButtons = categoriesInfo.map { (category, endpoint) in
            let button = UIButton()
            buttonEndpointLookup[button] = endpoint
            button.backgroundColor = .greyF2()
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), forControlEvents: .TouchUpInside)
            let attributedString = CategoryListCell.buttonTitle(category)
            button.setAttributedTitle(attributedString, forState: UIControlState.Normal)

            return button
        }

        var prevView: UIView? = nil
        for view in categoryButtons {
            contentView.addSubview(view)

            view.snp_makeConstraints { make in
                make.top.bottom.equalTo(contentView)

                if let prevView = prevView {
                    make.leading.equalTo(prevView.snp_trailing).offset(Size.spacing)
                    make.width.equalTo(prevView)
                }
                else {
                    make.leading.equalTo(contentView)
                }
            }

            prevView = view
        }

        if let prevView = prevView {
            prevView.snp_makeConstraints { make in
                make.trailing.equalTo(contentView)
            }
        }
        setNeedsLayout()
    }

}
