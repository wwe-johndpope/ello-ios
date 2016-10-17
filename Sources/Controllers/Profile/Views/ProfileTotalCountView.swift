////
///  ProfileTotalCountView.swift
//

public class ProfileTotalCountView: ProfileBaseView {

    private let totalLabel = UILabel()
    private let badgeButton = UIButton()
    private let greyLine = UIView()

    public struct Size {
        static let height: CGFloat = 60
        static let shareMargin: CGFloat = 2
        static let shareWidth: CGFloat = 44
        static let shareHeight: CGFloat = 44
        static let badgeMargin: CGFloat = 12
        static let badgeWidth: CGFloat = 44
        static let badgeHeight: CGFloat = 44
    }

    static let totalFont = UIFont.defaultFont(14)

    public var count: String {
        get { return _count }
        set {
            _count = newValue
            updateCountText()
        }
    }

    private var _count = ""
    private let totalViewsText = ElloAttributedString.style(InterfaceString.Profile.TotalViews, [NSForegroundColorAttributeName: UIColor.greyA()])
}

extension ProfileTotalCountView {

    override func style() {
        backgroundColor = .whiteColor()
        totalLabel.textAlignment = .Center
        badgeButton.setImages(.BadgeCheck)
        greyLine.backgroundColor = .greyA()
    }

    override func bindActions() {
        badgeButton.addTarget(self, action: #selector(badgeTapped), forControlEvents: .TouchUpInside)
    }

    override func setText() {
        updateCountText()
    }

    override func arrange() {
        addSubview(totalLabel)
        addSubview(badgeButton)
        addSubview(greyLine)

        totalLabel.snp_makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.width.equalTo(self)
        }

        badgeButton.snp_makeConstraints { make in
            make.centerY.equalTo(self)
            make.trailing.equalTo(self).inset(Size.badgeMargin)
            make.width.equalTo(Size.badgeWidth)
            make.width.equalTo(Size.badgeWidth)
        }

        greyLine.snp_makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalTo(self)
            make.leading.trailing.equalTo(self).inset(ProfileBaseView.Size.grayInset)
        }

        layoutIfNeeded()
    }

    public func prepareForReuse() {
        // nothing here yet
    }
}

extension ProfileTotalCountView {

    func badgeTapped() {
        guard let cell: UICollectionViewCell = self.findParentView() else { return }

        let responder = targetForAction(#selector(ProfileHeaderResponder.onCategoryBadgeTapped(_:)), withSender: self) as? ProfileHeaderResponder
        responder?.onCategoryBadgeTapped(cell)
    }
}


private extension ProfileTotalCountView {

    func totalViewText(countText: String) -> NSAttributedString {
        let attributed = NSMutableAttributedString()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center

        let count = ElloAttributedString.style(countText + " ", [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSParagraphStyleAttributeName : paragraphStyle
        ])
        attributed.appendAttributedString(count)
        attributed.appendAttributedString(totalViewsText)
        return attributed
    }

    func updateCountText() {
        totalLabel.attributedText = totalViewText(count)
        setNeedsLayout()
    }
}

extension ProfileTotalCountView: ProfileViewProtocol {}
