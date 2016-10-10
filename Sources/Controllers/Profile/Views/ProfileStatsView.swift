////
///  ProfileStatsView.swift
//

public class ProfileStatsView: ProfileBaseView {
    public struct Size {
        static let verticalMargin: CGFloat = 1
        static let countVerticalOffset: CGFloat = 20
        static let captionVerticalOffset: CGFloat = 5
    }

    public var postsCount: String {
        get { return postsCountLabel.text ?? "" }
        set { postsCountLabel.text = newValue }
    }
    public var followingCount: String {
        get { return followingCountLabel.text ?? "" }
        set { followingCountLabel.text = newValue }
    }
    public var followersCount: String {
        get { return followersCountLabel.text ?? "" }
        set { followersCountLabel.text = newValue }
    }
    public var lovesCount: String {
        get { return lovesCountLabel.text ?? "" }
        set { lovesCountLabel.text = newValue }
    }

    private let postsCountLabel = UILabel()
    private let followingCountLabel = UILabel()
    private let followersCountLabel = UILabel()
    private let lovesCountLabel = UILabel()
    private var countLabels: [UILabel] {
        return [postsCountLabel, followingCountLabel, followersCountLabel, lovesCountLabel]
    }

    private let postsCaptionLabel = UILabel()
    private let followingCaptionLabel = UILabel()
    private let followersCaptionLabel = UILabel()
    private let lovesCaptionLabel = UILabel()
    private var captionLabels: [UILabel] {
        return [postsCaptionLabel, followingCaptionLabel, followersCaptionLabel, lovesCaptionLabel]
    }

    private let postsButton = UIButton()
    private let followingButton = UIButton()
    private let followersButton = UIButton()
    private let lovesButton = UIButton()
    private var buttons: [UIButton] {
        return [postsButton, followingButton, followersButton, lovesButton]
    }

    private var allThreeViews: [(count: UILabel, caption: UILabel, button: UIButton)] { return [
        (postsCountLabel,     postsCaptionLabel,     postsButton),
        (followingCountLabel, followingCaptionLabel, followingButton),
        (followersCountLabel, followersCaptionLabel, followersButton),
        (lovesCountLabel,     lovesCaptionLabel,     lovesButton),
    ]}

}

extension ProfileStatsView {

    override func style() {
        for countLabel in countLabels {
            countLabel.font = .defaultFont(18)
            countLabel.textColor = .greyA()
            countLabel.textAlignment = .Center
        }

        for captionLabel in captionLabels {
            captionLabel.font = .defaultFont()
            captionLabel.textColor = .blackColor()
            captionLabel.textAlignment = .Center
        }
    }

    override func bindActions() {
        postsButton.addTarget(self, action: #selector(postsButtonTapped), forControlEvents: .TouchUpInside)
        followingButton.addTarget(self, action: #selector(followingButtonTapped), forControlEvents: .TouchUpInside)
        followersButton.addTarget(self, action: #selector(followersButtonTapped), forControlEvents: .TouchUpInside)
        lovesButton.addTarget(self, action: #selector(lovesButtonTapped), forControlEvents: .TouchUpInside)
    }

    override func setText() {
        postsCaptionLabel.text = InterfaceString.Profile.PostsCount
        followingCaptionLabel.text = InterfaceString.Profile.FollowingCount
        followersCaptionLabel.text = InterfaceString.Profile.FollowersCount
        lovesCaptionLabel.text = InterfaceString.Profile.LovesCount
    }

    override func arrange() {
        var prevCountLabel: UIView?
        for (countLabel, captionLabel, button) in allThreeViews {
            addSubview(countLabel)
            addSubview(captionLabel)
            addSubview(button)

            countLabel.snp_makeConstraints { make in
                if let prevCountLabel = prevCountLabel {
                    make.width.equalTo(prevCountLabel)
                    make.leading.equalTo(prevCountLabel.snp_trailing)
                }
                else {
                    make.leading.equalTo(self)
                }
                make.top.equalTo(self).offset(Size.countVerticalOffset)
            }

            captionLabel.snp_makeConstraints { make in
                make.centerX.equalTo(countLabel)
                make.top.equalTo(countLabel.snp_bottom).offset(Size.captionVerticalOffset)
            }

            button.snp_makeConstraints { make in
                make.leading.trailing.equalTo(countLabel)
                make.top.bottom.equalTo(self)
            }

            prevCountLabel = countLabel
        }

        if let prevCountLabel = prevCountLabel {
            prevCountLabel.snp_makeConstraints { make in
                make.trailing.equalTo(self)
            }
        }

        layoutIfNeeded()
    }

    func prepareForReuse() {
        for countLabel in countLabels {
            countLabel.text = ""
        }
    }
}

extension ProfileStatsView {
    func postsButtonTapped() {
    }

    func followingButtonTapped() {
    }

    func followersButtonTapped() {
    }

    func lovesButtonTapped() {
    }
}

extension ProfileStatsView: ProfileViewProtocol {}
