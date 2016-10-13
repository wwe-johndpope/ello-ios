////
///  RelationshipControl.swift
//


public enum RelationshipControlStyle {
    case Default
    case ProfileView

    var starButtonMargin: CGFloat {
        switch self {
            case .ProfileView: return 10
            default: return 7
        }
    }

    var starButtonWidth: CGFloat {
        switch self {
            case .ProfileView: return 20
            default: return 30
        }
    }
}


public class RelationshipControl: UIView {
    struct Size {
        static let viewHeight: CGFloat = 30
        static let minViewWidth: CGFloat = 105
    }

    let followingButton = FollowButton()
    let starButton = StarButton()
    var style: RelationshipControlStyle = .Default {
        didSet {
            followingButton.relationshipStyle = style
            starButton.relationshipStyle = style
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
    }

    public var enabled: Bool {
        set {
            followingButton.enabled = newValue
            starButton.enabled = newValue
        }
        get { return followingButton.enabled }
    }
    public var userId: String
    public var userAtName: String

    public weak var relationshipDelegate: RelationshipDelegate?
    public var relationshipPriority: RelationshipPriority = .None {
        didSet { updateRelationshipPriority() }
    }

    public var showStarButton = true {
        didSet {
            starButton.hidden = !showStarButton
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
    }

    required public override init(frame: CGRect) {
        self.userId = ""
        self.userAtName = ""
        super.init(frame: frame)
        setup()
    }

    required public init?(coder: NSCoder) {
        self.userId = ""
        self.userAtName = ""
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        arrange()
        bindActions()
        starButton.hidden = !showStarButton
        updateRelationshipPriority()
        backgroundColor = .clearColor()
    }

    public override func intrinsicContentSize() -> CGSize {
        var totalSize = CGSize(width: 0, height: Size.viewHeight)
        let followingSize = followingButton.intrinsicContentSize()
        if followingSize.width > Size.minViewWidth {
            totalSize.width += followingSize.width
        }
        else {
            totalSize.width += Size.minViewWidth
        }

        if showStarButton {
            totalSize.width += style.starButtonWidth + style.starButtonMargin
        }

        return totalSize
    }

    // MARK: IBActions

    @IBAction func starButtonTapped(sender: UIButton) {
        switch relationshipPriority {
        case .Mute, .Block:
            launchUnmuteModal()
        case .Starred:
            handleUnstar()
        default:
            handleStar()
        }
    }

    @IBAction func followingButtonTapped(sender: UIButton) {
        switch relationshipPriority {
        case .Mute, .Block:
            launchUnmuteModal()
        case .Following:
            handleUnfollow()
        case .Starred:
            handleUnstar()
        default:
            handleFollow()
        }
    }

    private func launchUnmuteModal() {
        guard relationshipPriority.isMutedOrBlocked else {
            return
        }

        guard let relationshipDelegate = relationshipDelegate else {
            return
        }

        let prevRelationshipPriority = self.relationshipPriority
        relationshipDelegate.launchBlockModal(userId, userAtName: userAtName, relationshipPriority: prevRelationshipPriority) { newRelationshipPriority in
            self.relationshipPriority = newRelationshipPriority
        }
    }

    private func handleRelationship(newRelationshipPriority: RelationshipPriority) {
        guard let relationshipDelegate = relationshipDelegate else {
            return
        }

        self.userInteractionEnabled = false
        let prevRelationshipPriority = self.relationshipPriority
        self.relationshipPriority = newRelationshipPriority
        relationshipDelegate.relationshipTapped(self.userId, prev: prevRelationshipPriority, relationshipPriority: newRelationshipPriority) { (status, relationship, isFinalValue) in
            self.userInteractionEnabled = isFinalValue

            if let newRelationshipPriority = relationship?.subject?.relationshipPriority {
                self.relationshipPriority = newRelationshipPriority
            }
            else {
                self.relationshipPriority = prevRelationshipPriority
            }
        }
    }

    private func handleFollow() {
        handleRelationship(.Following)
    }

    private func handleStar() {
        handleRelationship(.Starred)
    }

    private func handleUnstar() {
        handleRelationship(.Following)
    }

    private func handleUnfollow() {
        handleRelationship(.Inactive)
    }

    // MARK: Private

    private func arrange() {
        addSubview(starButton)
        addSubview(followingButton)
    }

    private func bindActions() {
        followingButton.addTarget(self, action: #selector(RelationshipControl.followingButtonTapped(_:)), forControlEvents: .TouchUpInside)
        starButton.addTarget(self, action: #selector(RelationshipControl.starButtonTapped(_:)), forControlEvents: .TouchUpInside)
    }

    private func updateRelationshipPriority() {
        let config: Config
        switch relationshipPriority {
        case .Following: config = .Following
        case .Starred: config = .Starred
        case .Mute: config = .Muted
        case .Block: config = .Blocked
        default: config = .None
        }

        followingButton.config = config
        starButton.config = config
        starButton.hidden = relationshipPriority.isMutedOrBlocked || !showStarButton

        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let starButtonWidth: CGFloat
        if !relationshipPriority.isMutedOrBlocked && showStarButton {
            starButton.frame = CGRect(x: frame.width - style.starButtonWidth, y: 0, width: style.starButtonWidth, height: Size.viewHeight)
            starButtonWidth = style.starButtonWidth + style.starButtonMargin
        }
        else {
            starButton.frame = .zero
            starButtonWidth = 0
        }

        followingButton.frame = bounds.inset(top: 0, left: 0, bottom: 0, right: starButtonWidth)
    }

    private enum Config {
        case Starred
        case Following
        case Muted
        case Blocked
        case None

        var title: String {
            switch self {
            case .None: return InterfaceString.Relationship.Follow
            case .Following: return InterfaceString.Relationship.Following
            case .Starred: return InterfaceString.Relationship.Starred
            case .Muted: return InterfaceString.Relationship.Muted
            case .Blocked: return InterfaceString.Relationship.Blocked
            }
        }

        var starred: Bool {
            return self == .Starred
        }

        var image: UIImage? {
            switch self {
            case .Muted, .Blocked: return nil
            case .Starred, .Following: return InterfaceImage.CheckSmall.whiteImage
            default: return InterfaceImage.PlusSmall.selectedImage
            }
        }

        var highlightedImage: UIImage? {
            switch self {
            case .Muted, .Blocked, .Starred, .Following: return self.image
            default: return InterfaceImage.PlusSmall.whiteImage
            }
        }
    }

    class FollowButton: StyledButton {
        var relationshipStyle: RelationshipControlStyle = .Default {
            didSet { recalculateStyle() }
        }
        private var config: Config = .None {
            didSet { recalculateStyle() }
        }

        private func recalculateStyle() {
            let style: StyledButton.Style
            var image: UIImage? = nil
            var highlightedImage: UIImage? = nil

            if config == .Following || config == .Starred {
                if relationshipStyle == .ProfileView {
                    style = .GrayPill
                }
                else {
                    style = .BlackPill
                }
                image = InterfaceImage.CheckSmall.whiteImage
                highlightedImage = image
            }
            else if config == .Muted || config == .Blocked {
                style = .RedPill
            }
            else if relationshipStyle == .ProfileView && config == .None {
                style = .GreenPill
                image = InterfaceImage.PlusSmall.whiteImage
                highlightedImage = image
            }
            else {
                style = .BlackPillOutline
                image = InterfaceImage.PlusSmall.selectedImage
                highlightedImage = InterfaceImage.PlusSmall.whiteImage
            }

            setTitle(config.title, forState: .Normal)
            setImage(image, forState: .Normal)
            setImage(highlightedImage, forState: .Highlighted)
            setImage(UIImage(), forState: .Disabled)
            self.style = style
        }

        override func sharedSetup() {
            super.sharedSetup()
            contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 10)
            adjustsImageWhenDisabled = false
            recalculateStyle()
        }
    }

    class StarButton: StyledButton {
        var relationshipStyle: RelationshipControlStyle = .Default {
            didSet { recalculateStyle() }
        }
        private var config: Config = .None {
            didSet { recalculateStyle() }
        }

        private func recalculateStyle() {
            var image: UIImage? = nil
            var highlightedImage: UIImage? = nil

            if config == .Starred {
                image = InterfaceImage.Star.whiteImage
                highlightedImage = image
            }
            else if relationshipStyle == .ProfileView {
                image = InterfaceImage.Star.selectedImage
                highlightedImage = InterfaceImage.Star.whiteImage
            }
            else {
                image = InterfaceImage.Star.normalImage
                highlightedImage = InterfaceImage.Star.whiteImage
            }

            setImage(image, forState: .Normal)
            setImage(highlightedImage, forState: .Highlighted)
            setImage(UIImage(), forState: .Disabled)
        }

        override func sharedSetup() {
            super.sharedSetup()

            adjustsImageWhenDisabled = false
            config = .None
            style = .ClearWhite
            recalculateStyle()
        }
    }
}
