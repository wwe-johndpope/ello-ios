////
///  ProfileAvatarView.swift
//

public class ProfileAvatarView: ProfileBaseView {

    public struct Size {
        static let avatarWidth: CGFloat = 215
        static let avatarHeight: CGFloat = 215
        static let avatarBottomMargin: CGFloat = 10
        static let whiteBarHeight: CGFloat = 80
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

    private let avatarImageView = FLAnimatedImageView()
    private let whiteBar = UIView()
    private var _avatarURL: NSURL?

}

extension ProfileAvatarView {

    override func style() {
        backgroundColor = .clearColor()
        avatarImageView.backgroundColor = .yellowColor()
        avatarImageView.clipsToBounds = true
        whiteBar.backgroundColor = .whiteColor()
    }

    override func bindActions() {}

    override func setText() {}

    override func arrange() {
        super.arrange()

        addSubview(whiteBar)
        addSubview(avatarImageView)

        avatarImageView.snp_makeConstraints { make in
            make.width.equalTo(Size.avatarWidth)
            make.height.equalTo(Size.avatarHeight)
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-Size.avatarBottomMargin)
        }

        whiteBar.snp_makeConstraints { make in
            make.leading.trailing.equalTo(self)
            make.height.equalTo(Size.whiteBarHeight)
            make.bottom.equalTo(self.snp_bottom)
        }

        layoutIfNeeded()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = Size.avatarWidth / 2
    }

    public func prepareForReuse() {
        avatarImageView.pin_cancelImageDownload()
        avatarImageView.image = nil
        _avatarURL = nil
    }
}

extension ProfileAvatarView: ProfileViewProtocol {}
