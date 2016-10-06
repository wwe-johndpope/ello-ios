////
///  ProfileHeaderCompactView.swift
//

public class ProfileHeaderCompactView: ProfileBaseView {

    public struct Size {
        static let avatarWidth: CGFloat = 122
        static let avatarHeight: CGFloat = 122

        static let nameWidth: CGFloat = 122
        static let nameHeight: CGFloat = 122

        static let viewsWidth: CGFloat = 122
        static let viewsHeight: CGFloat = 122

        static let activityWidth: CGFloat = 122
        static let activityHeight: CGFloat = 122

        static let bioWidth: CGFloat = 122
        static let bioHeight: CGFloat = 122

        static let linksWidth: CGFloat = 122
        static let linksHeight: CGFloat = 122
    }

    let avatarView = ProfileAvatarView()
    let nameView = ProfileNameView()
    let viewsView = ProfileViewsView()
    let activityView = ProfileActivityView()
    let bioView = ProfileBioView()
    let linksView = ProfileLinksView()
}

extension ProfileHeaderCompactView {

    override func style() {
        backgroundColor = .grayColor()
    }

    override func bindActions() {}

    override func setText() {}

    override func arrange() {
        super.arrange()

        addSubview(avatarView)
        addSubview(nameView)
        addSubview(viewsView)
        addSubview(activityView)
        addSubview(bioView)
        addSubview(linksView)

        avatarView.snp_makeConstraints { make in
            make.top.equalTo(self.snp_top)
            make.width.equalTo(self.snp_width)
            make.height.equalTo(Size.avatarHeight)
        }

        nameView.snp_makeConstraints { make in
            make.width.equalTo(self.snp_width)
            make.height.equalTo(Size.nameHeight)
            make.top.equalTo(self.avatarView.snp_bottom)
        }

        viewsView.snp_makeConstraints { make in
            make.width.equalTo(self.snp_width)
            make.height.equalTo(Size.viewsHeight)
            make.top.equalTo(self.nameView.snp_bottom)
        }

        activityView.snp_makeConstraints { make in
            make.width.equalTo(self.snp_width)
            make.height.equalTo(Size.activityHeight)
            make.top.equalTo(self.viewsView.snp_bottom)
        }

        bioView.snp_makeConstraints { make in
            make.width.equalTo(self.snp_width)
            make.height.equalTo(Size.bioHeight)
            make.top.equalTo(self.activityView.snp_bottom)
        }

        linksView.snp_makeConstraints { make in
            make.width.equalTo(self.snp_width)
            make.height.equalTo(Size.linksHeight)
            make.top.equalTo(self.bioView.snp_bottom)
        }

        layoutIfNeeded()
    }
}
