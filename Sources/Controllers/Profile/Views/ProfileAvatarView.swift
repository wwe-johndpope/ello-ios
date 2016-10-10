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

    let avatarImage = FLAnimatedImageView()
    let whiteBar = UIView()
}

extension ProfileAvatarView {

    override func style() {
        backgroundColor = .clearColor()
        avatarImage.backgroundColor = .yellowColor()
        avatarImage.clipsToBounds = true
        whiteBar.backgroundColor = .whiteColor()

    }

    override func bindActions() {}

    override func setText() {
    }

    override func arrange() {
        super.arrange()

        addSubview(whiteBar)
        addSubview(avatarImage)

        avatarImage.snp_makeConstraints { make in
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
        avatarImage.layer.cornerRadius = Size.avatarWidth / 2
    }

    public func setAvatar(image: UIImage?) {
        avatarImage.image = image
    }

    public func setAvatarURL(url: NSURL) {
        avatarImage.pin_setImageFromURL(url) { _ in
            // we may need to notify the cell of this
            // previously we hid the loader here
        }
    }

    public func prepareForReuse() {
        avatarImage.pin_cancelImageDownload()
        avatarImage.image = nil
    }
}

extension ProfileAvatarView: ProfileViewProtocol {}
