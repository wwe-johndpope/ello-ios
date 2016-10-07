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

    func setAvatar(image: UIImage?) {}

    func setAvatarURL(url: NSURL) {}
}
