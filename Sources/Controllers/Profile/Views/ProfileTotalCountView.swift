////
///  ProfileTotalCountView.swift
//

public class ProfileTotalCountView: ProfileBaseView {

    let totalLabel = UILabel()
    let badgeButton = UIButton()
    let shareButton = UIButton()

    public struct Size {
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
        shareButton.setImages(.Share)
    }

    override func bindActions() {
        badgeButton.addTarget(self, action: #selector(badgeTapped), forControlEvents: .TouchUpInside)
        shareButton.addTarget(self, action: #selector(shareTapped), forControlEvents: .TouchUpInside)
    }

    override func setText() {
        updateCountText()
    }

    override func arrange() {
        addSubview(totalLabel)
        addSubview(badgeButton)
        addSubview(shareButton)

        totalLabel.snp_makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.width.equalTo(self)
        }

        shareButton.snp_makeConstraints { make in
            make.trailing.equalTo(self.snp_trailing).offset(-Size.shareMargin)
            make.centerY.equalTo(self)
            make.width.equalTo(Size.shareWidth)
            make.height.equalTo(Size.shareHeight)
        }

        badgeButton.snp_makeConstraints { make in
            make.centerY.equalTo(self)
            make.trailing.equalTo(self.shareButton.snp_leading).offset(Size.badgeMargin)
            make.width.equalTo(Size.badgeWidth)
            make.width.equalTo(Size.badgeWidth)
        }

        layoutIfNeeded()
    }
}

extension ProfileTotalCountView {
    func badgeTapped() {
    }

    func shareTapped() {
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
