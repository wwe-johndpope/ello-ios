////
///  ProfileHeaderCompactView.swift
//

import SnapKit


public class ProfileHeaderCompactView: ProfileBaseView {
    public struct Size {
        static let avatarHeight: CGFloat = 255
        static let totalCountHeight: CGFloat = 60
    }

    let avatarView = ProfileAvatarView()
    let namesView = ProfileNamesView()
    let totalCountView = ProfileTotalCountView()
    let statsView = ProfileStatsView()
    let bioView = ProfileBioView()
    let linksView = ProfileLinksView()

    var calculatedCellHeights: CalculatedCellHeights? {
        didSet {
            guard let calculatedCellHeights = calculatedCellHeights else { return }

            if let namesHeight = calculatedCellHeights.profileNames { namesHeightConstraint.updateOffset(namesHeight) }
            if let bioHeight = calculatedCellHeights.profileBio { bioHeightConstraint.updateOffset(bioHeight) }
            if let linksHeight = calculatedCellHeights.profileLinks { linksHeightConstraint.updateOffset(linksHeight) }
            setNeedsLayout()
        }
    }

    var namesHeightConstraint: Constraint!
    var bioHeightConstraint: Constraint!
    var linksHeightConstraint: Constraint!
}

extension ProfileHeaderCompactView {

    override func style() {
        backgroundColor = .clearColor()
    }

    override func bindActions() {}

    override func setText() {}

    override func arrange() {
        super.arrange()

        addSubview(avatarView)
        addSubview(namesView)
        addSubview(totalCountView)
        addSubview(statsView)
        addSubview(bioView)
        addSubview(linksView)

        avatarView.snp_makeConstraints { make in
            make.top.width.centerX.equalTo(self)
            make.height.equalTo(Size.avatarHeight)
        }

        namesView.snp_makeConstraints { make in
            make.top.equalTo(self.avatarView.snp_bottom)
            make.width.centerX.equalTo(self)
            namesHeightConstraint = make.height.equalTo(0).constraint
        }

        totalCountView.snp_makeConstraints { make in
            make.top.equalTo(self.namesView.snp_bottom)
            make.width.centerX.equalTo(self)
            make.height.equalTo(Size.totalCountHeight)
        }

        statsView.snp_makeConstraints { make in
            make.top.equalTo(self.totalCountView.snp_bottom)
            make.width.centerX.equalTo(self)
            make.height.equalTo(ProfileStatsView.Size.height)
        }

        bioView.snp_makeConstraints { make in
            make.top.equalTo(self.statsView.snp_bottom)
            make.width.centerX.equalTo(self)
            bioHeightConstraint = make.height.equalTo(0).constraint
        }

        linksView.snp_makeConstraints { make in
            make.top.equalTo(self.bioView.snp_bottom)
            make.width.centerX.equalTo(self)
            linksHeightConstraint = make.height.equalTo(0).constraint
        }
    }
}
