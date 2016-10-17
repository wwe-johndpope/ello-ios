////
///  ProfileHeaderCell.swift
//

@objc
public protocol EditProfileResponder {
    func onEditProfile()
}

@objc
public protocol PostsTappedResponder {
    func onPostsTapped()
}

public class ProfileHeaderCell: UICollectionViewCell {
    static let reuseIdentifier = "ProfileHeaderCell"

    let headerView = ProfileHeaderCompactView()

    var avatarView: ProfileAvatarView { get { return headerView.avatarView } }
    var namesView: ProfileNamesView { get { return headerView.namesView } }
    var totalCountView: ProfileTotalCountView { get { return headerView.totalCountView } }
    var statsView: ProfileStatsView { get { return headerView.statsView } }
    var bioView: ProfileBioView { get { return headerView.bioView } }
    var linksView: ProfileLinksView { get { return headerView.linksView } }

    typealias WebContentReady = (webView: UIWebView) -> Void

    // this little hack prevents constraints from breaking on initial load
    override public var bounds: CGRect {
        didSet {
          contentView.frame = bounds
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        arrange()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func arrange() {
        backgroundColor = .clearColor()
        contentView.backgroundColor = .clearColor()
        contentView.addSubview(headerView)

        headerView.snp_makeConstraints { make in
            make.edges.equalTo(self.contentView)
        }
    }

    weak var webLinkDelegate: WebLinkDelegate?
    weak var simpleStreamDelegate: SimpleStreamDelegate?
    var user: User?
    var currentUser: User?
    var webContentReady: WebContentReady?

    func showPlaceholders() {}

    public override func prepareForReuse() {
        avatarView.prepareForReuse()
        statsView.prepareForReuse()
        totalCountView.prepareForReuse()
        bioView.prepareForReuse()
    }
}
