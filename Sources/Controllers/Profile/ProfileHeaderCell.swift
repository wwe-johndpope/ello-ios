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

    typealias WebContentReady = (webView: UIWebView) -> Void

    // this little hack prevents constraints from breaking on initial load
    override public var bounds: CGRect {
        didSet {
          contentView.frame = bounds
        }
    }

    @IBOutlet weak var loaderView: InterpolatedLoadingView!
    @IBOutlet weak var avatarImage: FLAnimatedImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var placeholders: UIView!
    @IBOutlet weak var nameLabel: ElloLabel!
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bioWebView: UIWebView!
    @IBOutlet weak var postsButton: TwoLineButton!
    @IBOutlet weak var followersButton: TwoLineButton!
    @IBOutlet weak var followingButton: TwoLineButton!
    @IBOutlet weak var lovesButton: TwoLineButton!

    var webViewHeight: CGFloat {
        get { return webViewHeightConstraint.constant }
        set {
            webViewHeightConstraint.constant = newValue
            bioWebView.frame.size.height = newValue
        }
    }

    weak var webLinkDelegate: WebLinkDelegate?
    weak var simpleStreamDelegate: SimpleStreamDelegate?
    var user: User?
    var currentUser: User?
    var webContentReady: WebContentReady?

    override public func awakeFromNib() {
        super.awakeFromNib()
        style()
        setText()
        bioWebView.delegate = self
        usernameLabel.text = ""
        nameLabel.text = ""
    }

    func onWebContentReady(handler: WebContentReady?) {
        webContentReady = handler
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        avatarImage.layer.cornerRadius = avatarWidthConstraint.constant / 2
        bioWebView.scrollView.scrollEnabled = false
        bioWebView.scrollView.scrollsToTop = false
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        loaderView.hidden = false
        avatarImage.pin_cancelImageDownload()
        avatarImage.image = nil
        bioWebView.stopLoading()
        bioWebView.loadHTMLString("", baseURL: nil)
        currentUser = nil
        user = nil
        usernameLabel.text = ""
        nameLabel.text = ""
        postsButton.hidden = false
        postsButton.count = ""
        followersButton.hidden = false
        followingButton.count = ""
        followingButton.hidden = false
        lovesButton.count = ""
        lovesButton.hidden = false
        followersButton.count = ""
        placeholders.hidden = true
    }

    func showPlaceholders() {
        postsButton.hidden = true
        followersButton.hidden = true
        followingButton.hidden = true
        lovesButton.hidden = true

        placeholders.hidden = false
        for view in placeholders.subviews {
            view.backgroundColor = .greyF2()
        }
    }

    func setAvatar(image: UIImage?) {
        avatarImage.image = image
        loaderView.hidden = true
    }

    func setAvatarURL(url: NSURL) {
        avatarImage.pin_setImageFromURL(url) { result in
            self.loaderView.hidden = false
        }
    }

    private func style() {
        usernameLabel.font = UIFont.defaultBoldFont(18)
        usernameLabel.textColor = UIColor.blackColor()

        nameLabel.font = UIFont.defaultFont()
        nameLabel.textColor = UIColor.greyA()
        nameLabel.lineBreakMode = .ByWordWrapping
    }

    private func setText() {
        postsButton.title = InterfaceString.Profile.PostsCount
        followingButton.title = InterfaceString.Profile.FollowingCount
        lovesButton.title = InterfaceString.Profile.LovesCount
        followersButton.title = InterfaceString.Profile.FollowersCount
    }

    @IBAction func editProfileTapped(sender: UIButton) {
        let responder = targetForAction(#selector(EditProfileResponder.onEditProfile), withSender: self) as? EditProfileResponder
        responder?.onEditProfile()
    }

    @IBAction func followingTapped(sender: UIButton) {
        guard let user = user else { return }

        let noResultsTitle: String
        let noResultsBody: String
        if user.id == currentUser?.id {
            noResultsTitle = InterfaceString.Following.CurrentUserNoResultsTitle
            noResultsBody = InterfaceString.Following.CurrentUserNoResultsBody
        }
        else {
            noResultsTitle = InterfaceString.Following.NoResultsTitle
            noResultsBody = InterfaceString.Following.NoResultsBody
        }
        simpleStreamDelegate?.showSimpleStream(.UserStreamFollowing(userId: user.id), title: InterfaceString.Following.Title, noResultsMessages: (title: noResultsTitle, body: noResultsBody))
    }

    @IBAction func followersTapped(sender: UIButton) {
        guard let user = user else { return }

        let noResultsTitle: String
        let noResultsBody: String
        if user.id == currentUser?.id {
            noResultsTitle = InterfaceString.Followers.CurrentUserNoResultsTitle
            noResultsBody = InterfaceString.Followers.CurrentUserNoResultsBody
        }
        else {
            noResultsTitle = InterfaceString.Followers.NoResultsTitle
            noResultsBody = InterfaceString.Followers.NoResultsBody
        }
        simpleStreamDelegate?.showSimpleStream(.UserStreamFollowers(userId: user.id), title: InterfaceString.Followers.Title, noResultsMessages: (title: noResultsTitle, body: noResultsBody))
    }

    @IBAction func lovesTapped(sender: UIButton) {
        guard let user = user else { return }

        let noResultsTitle: String
        let noResultsBody: String
        if user.id == currentUser?.id {
            noResultsTitle = InterfaceString.Loves.CurrentUserNoResultsTitle
            noResultsBody = InterfaceString.Loves.CurrentUserNoResultsBody
        }
        else {
            noResultsTitle = InterfaceString.Loves.NoResultsTitle
            noResultsBody = InterfaceString.Loves.NoResultsBody
        }
        simpleStreamDelegate?.showSimpleStream(.Loves(userId: user.id), title: InterfaceString.Loves.Title, noResultsMessages: (title: noResultsTitle, body: noResultsBody))
    }

    @IBAction func postsTapped(sender: UIButton) {
        guard user != nil else { return }

        let responder = targetForAction(#selector(PostsTappedResponder.onPostsTapped), withSender: self) as? PostsTappedResponder
        responder?.onPostsTapped()
    }
}

extension ProfileHeaderCell: UIWebViewDelegate {
    public func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return ElloWebViewHelper.handleRequest(request, webLinkDelegate: webLinkDelegate)
    }

    public func webViewDidFinishLoad(webView: UIWebView) {
        UIView.animateWithDuration(0.15) {
            self.contentView.alpha = 1.0
        }
        webContentReady?(webView: webView)
    }
}
