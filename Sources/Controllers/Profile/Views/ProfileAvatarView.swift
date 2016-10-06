////
///  ProfileAvatarView.swift
//

public class ProfileAvatarView: ProfileBaseView {

    let tmpLabel = UITextField()

    public struct Size {
        static let avatarWidth: CGFloat = 122
        static let avatarHeight: CGFloat = 122
    }

    let avatarImage = FLAnimatedImageView()
}

extension ProfileAvatarView {

    override func style() {
        backgroundColor = .purpleColor()
    }

    override func bindActions() {}

    override func setText() {
        tmpLabel.text = "Avatar View"
        tmpLabel.textAlignment = .Center
    }

    override func arrange() {
        super.arrange()

        addSubview(avatarImage)
        addSubview(tmpLabel)

        avatarImage.snp_makeConstraints { make in
            make.width.equalTo(Size.avatarWidth)
            make.height.equalTo(Size.avatarHeight)
        }

        tmpLabel.snp_makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.width.equalTo(self)
        }

        layoutIfNeeded()
    }
}

extension ProfileAvatarView: ProfileViewProtocol {}
