////
///  ProfileAvatarView.swift
//

public class ProfileAvatarView: ProfileBaseView {

    public struct Size {
        static let height: CGFloat = 271
        static let avatarWidth: CGFloat = 180
        static let avatarHeight: CGFloat = 180
        static let whiteBarHeight: CGFloat = 60
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
        avatarImageView.backgroundColor = .greyF2()
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
            make.bottom.equalTo(self)
        }

        whiteBar.snp_makeConstraints { make in
            make.leading.trailing.equalTo(self)
            make.height.equalTo(Size.whiteBarHeight)
            make.bottom.equalTo(self.snp_bottom)
        }
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
