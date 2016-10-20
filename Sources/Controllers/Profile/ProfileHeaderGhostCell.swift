////
///  ProfileHeaderGhostCell.swift
//

public class ProfileHeaderGhostCell: UICollectionViewCell {
    static let reuseIdentifier = "ProfileHeaderGhostCell"

    struct Size {
        static let height: CGFloat = 460
        static let sideMargin: CGFloat = 15
        static let whiteTopMargin: CGFloat = 212
        static let avatarTopMargin: CGFloat = 90
        static let avatarSize: CGFloat = 180
        static let ghostHeight: CGFloat = 10
        static let nameTopMargin: CGFloat = 20
        static let nameWidth: CGFloat = 135
        static let nameBottomMargin: CGFloat = 15
        static let totalCountTopMargin: CGFloat = 24
        static let totalCountLeftWidth: CGFloat = 30
        static let totalCountInnerMargin: CGFloat = 13
        static let totalCountRightWidth: CGFloat = 60
        static let totalCountBottomMargin: CGFloat = 24
        static let statsTopMargin: CGFloat = 15
        static let statsInnerMargin: CGFloat = 7
        static let statsTopWidth: CGFloat = 30
        static let statsBottomWidth: CGFloat = 60
        static let statsBottomMargin: CGFloat = 28
    }

    private let whiteBackground = UIView()
    private let avatar = UIView()
    private let name = UIView()
    private let nameGrayLine = UIView()
    private let totalCountContainer = UIView()
    private let totalCountLeft = UIView()
    private let totalCountRight = UIView()
    private let totalCountGrayLine = UIView()
    private let statsContainer = UIView()
    private let stat1Container = UIView()
    private let stat1Top = UIView()
    private let stat1Bottom = UIView()
    private let stat2Container = UIView()
    private let stat2Top = UIView()
    private let stat2Bottom = UIView()
    private let stat3Container = UIView()
    private let stat3Top = UIView()
    private let stat3Bottom = UIView()
    private let stat4Container = UIView()
    private let stat4Top = UIView()
    private let stat4Bottom = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        arrange()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func style() {
        whiteBackground.backgroundColor = .whiteColor()
        let ghostsViews = [avatar, name, totalCountLeft, totalCountRight, stat1Top, stat1Bottom, stat2Top, stat2Bottom, stat3Top, stat3Bottom, stat4Top, stat4Bottom]
        for view in ghostsViews {
            view.backgroundColor = .greyF2()
        }
        avatar.layer.cornerRadius = Size.avatarSize / 2

        let lines = [nameGrayLine, totalCountGrayLine]
        for view in lines {
            view.backgroundColor = .greyF2()
        }
    }

    private func arrange() {
        addSubview(whiteBackground)

        addSubview(avatar)
        addSubview(name)

        addSubview(nameGrayLine)

        addSubview(totalCountContainer)
        totalCountContainer.addSubview(totalCountLeft)
        totalCountContainer.addSubview(totalCountRight)

        addSubview(totalCountGrayLine)

        addSubview(statsContainer)
        statsContainer.addSubview(stat1Container)
        stat1Container.addSubview(stat1Top)
        stat1Container.addSubview(stat1Bottom)

        statsContainer.addSubview(stat2Container)
        stat2Container.addSubview(stat2Top)
        stat2Container.addSubview(stat2Bottom)

        statsContainer.addSubview(stat3Container)
        stat3Container.addSubview(stat3Top)
        stat3Container.addSubview(stat3Bottom)

        statsContainer.addSubview(stat4Container)
        stat4Container.addSubview(stat4Top)
        stat4Container.addSubview(stat4Bottom)

        whiteBackground.snp_makeConstraints { make in
            make.top.equalTo(self).offset(Size.whiteTopMargin)
            make.leading.trailing.bottom.equalTo(self)
        }
        avatar.snp_makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(Size.avatarTopMargin)
            make.width.height.equalTo(Size.avatarSize)
        }
        name.snp_makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(avatar.snp_bottom).offset(Size.nameTopMargin)
            make.width.equalTo(Size.nameWidth)
            make.height.equalTo(Size.ghostHeight)
        }
        nameGrayLine.snp_makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(Size.sideMargin)
            make.top.equalTo(name.snp_bottom).offset(Size.nameBottomMargin)
            make.height.equalTo(1)
        }
        totalCountContainer.snp_makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(nameGrayLine.snp_bottom).offset(Size.totalCountTopMargin)
            make.leading.equalTo(totalCountLeft)
            make.trailing.equalTo(totalCountRight)
            make.height.equalTo(Size.ghostHeight)
        }
        totalCountLeft.snp_makeConstraints { make in
            make.width.equalTo(Size.totalCountLeftWidth)
            make.top.bottom.equalTo(totalCountContainer)
        }
        totalCountRight.snp_makeConstraints { make in
            make.width.equalTo(Size.totalCountRightWidth)
            make.leading.equalTo(totalCountLeft.snp_trailing).offset(Size.totalCountInnerMargin)
            make.top.bottom.equalTo(totalCountContainer)
        }
        totalCountGrayLine.snp_makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(Size.sideMargin)
            make.top.equalTo(totalCountContainer.snp_bottom).offset(Size.totalCountBottomMargin)
            make.height.equalTo(1)
        }
        statsContainer.snp_makeConstraints { make in
            make.leading.equalTo(self).offset(Size.sideMargin)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self).offset(-Size.statsBottomMargin)
            make.top.equalTo(totalCountGrayLine.snp_bottom).offset(Size.statsTopMargin)
        }
        stat1Container.snp_makeConstraints { make in
            make.top.bottom.leading.equalTo(statsContainer)
            make.width.equalTo(statsContainer).dividedBy(4)
        }
        stat1Top.snp_makeConstraints { make in
            make.top.leading.equalTo(stat1Container)
            make.width.equalTo(Size.statsTopWidth)
            make.height.equalTo(Size.ghostHeight)
        }
        stat1Bottom.snp_makeConstraints { make in
            make.top.equalTo(stat1Top.snp_bottom).offset(Size.statsInnerMargin)
            make.leading.equalTo(stat1Container)
            make.width.equalTo(Size.statsBottomWidth)
            make.height.equalTo(Size.ghostHeight)
        }
        stat2Container.snp_makeConstraints { make in
            make.top.bottom.width.equalTo(stat1Container)
            make.leading.equalTo(stat1Container.snp_trailing)
        }
        stat2Top.snp_makeConstraints { make in
            make.top.leading.equalTo(stat2Container)
            make.width.equalTo(Size.statsTopWidth)
            make.height.equalTo(Size.ghostHeight)
        }
        stat2Bottom.snp_makeConstraints { make in
            make.top.equalTo(stat2Top.snp_bottom).offset(Size.statsInnerMargin)
            make.leading.equalTo(stat2Container)
            make.width.equalTo(Size.statsBottomWidth)
            make.height.equalTo(Size.ghostHeight)
        }
        stat3Container.snp_makeConstraints { make in
            make.leading.equalTo(stat2Container.snp_trailing)
            make.top.bottom.width.equalTo(stat1Container)
        }
        stat3Top.snp_makeConstraints { make in
            make.top.leading.equalTo(stat3Container)
            make.width.equalTo(Size.statsTopWidth)
            make.height.equalTo(Size.ghostHeight)
        }
        stat3Bottom.snp_makeConstraints { make in
            make.top.equalTo(stat3Top.snp_bottom).offset(Size.statsInnerMargin)
            make.leading.equalTo(stat3Container)
            make.width.equalTo(Size.statsBottomWidth)
            make.height.equalTo(Size.ghostHeight)
        }
        stat4Container.snp_makeConstraints { make in
            make.trailing.equalTo(statsContainer)
            make.leading.equalTo(stat3Container.snp_trailing)
            make.top.bottom.width.equalTo(stat1Container)
        }
        stat4Top.snp_makeConstraints { make in
            make.top.leading.equalTo(stat4Container)
            make.width.equalTo(Size.statsTopWidth)
            make.height.equalTo(Size.ghostHeight)
        }
        stat4Bottom.snp_makeConstraints { make in
            make.top.equalTo(stat4Top.snp_bottom).offset(Size.statsInnerMargin)
            make.leading.equalTo(stat4Container)
            make.width.equalTo(Size.statsBottomWidth)
            make.height.equalTo(Size.ghostHeight)
        }
    }
}
