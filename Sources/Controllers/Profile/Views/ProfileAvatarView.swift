////
///  ProfileAvatarView.swift
//

public class ProfileAvatarView: ProfileBaseView {

    public struct Size {
        static let avatarSize: CGFloat = 180
        static let whiteBarHeight: CGFloat = 60

        static let badgeMarginTop: CGFloat = 8
        static let badgeMarginTrailing: CGFloat = -3
        static let badgeWidth: CGFloat = 44
        static let badgeHeight: CGFloat = 44
    }

    public var avatarImage: UIImage? {
        get { return avatarImageView.image }
        set { avatarImageView.image = newValue }
    }

    public var avatarURL: NSURL? {
        get { return _avatarURL }
        set {
            _avatarURL = newValue
            avatarImageView.pin_setImageFromURL(_avatarURL) { _ in
                // we may need to notify the cell of this
                // previously we hid the loader here
            }
        }
    }

    // temporarily move badge button here. Remove once Total Views is available
    private let badgeButton = UIButton()

    public var badgeVisible: Bool {
        set { badgeButton.hidden = !newValue }
        get { return !badgeButton.hidden }
    }

    private let avatarImageView = FLAnimatedImageView()
    private let whiteBar = UIView()
    private var _avatarURL: NSURL?

    var onHeightMismatch: OnHeightMismatch?
}

extension ProfileAvatarView {

    override func style() {
        backgroundColor = .clearColor()
        avatarImageView.backgroundColor = .greyF2()
        avatarImageView.clipsToBounds = true
        whiteBar.backgroundColor = .whiteColor()
        badgeButton.setImages(.BadgeCheck)
    }

    override func bindActions() {
        badgeButton.addTarget(self, action: #selector(badgeTapped), forControlEvents: .TouchUpInside)
    }

    override func setText() {}

    override func arrange() {
        super.arrange()

        addSubview(whiteBar)
        addSubview(avatarImageView)
        addSubview(badgeButton)

        avatarImageView.snp_makeConstraints { make in
            make.width.height.equalTo(Size.avatarSize)
            make.centerX.equalTo(self)
            make.bottom.equalTo(self)
        }

        whiteBar.snp_makeConstraints { make in
            make.leading.trailing.equalTo(self)
            make.height.equalTo(Size.whiteBarHeight)
            make.bottom.equalTo(self.snp_bottom)
        }

        badgeButton.snp_makeConstraints { make in
            make.top.equalTo(whiteBar.snp_top).offset(Size.badgeMarginTop)
            make.trailing.equalTo(self).inset(Size.badgeMarginTrailing)
            make.width.equalTo(Size.badgeWidth)
            make.width.equalTo(Size.badgeWidth)
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = Size.avatarSize / 2

        let desiredHeight = ProfileAvatarSizeCalculator.calculateHeight(maxWidth: frame.width)
        if desiredHeight != frame.height {
            onHeightMismatch?(desiredHeight)
        }
    }

    public func prepareForReuse() {
        avatarImageView.pin_cancelImageDownload()
        avatarImageView.image = nil
        _avatarURL = nil
    }
}
extension ProfileAvatarView {

    func badgeTapped() {
        guard let cell: UICollectionViewCell = self.findParentView() else { return }

        let responder = targetForAction(#selector(ProfileHeaderResponder.onCategoryBadgeTapped(_:)), withSender: self) as? ProfileHeaderResponder
        responder?.onCategoryBadgeTapped(cell)
    }
}

extension ProfileAvatarView: ProfileViewProtocol {}
