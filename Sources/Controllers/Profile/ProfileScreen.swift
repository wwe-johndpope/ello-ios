////
///  ProfileScreen.swift
//

public protocol ProfileScreenProtocol: class {
    func disableButtons()
    func enableButtons()
    func configureButtonsForCurrentUser()
    func configureButtonsForNonCurrentUser(isHireable: Bool)
    func resetCoverImage()
    func updateGradientViewConstraint(contentOffset: CGPoint, navBarsVisible: Bool)
    var relationshipDelegate: RelationshipDelegate? { get set }
    var navBar: ElloNavigationBar { get }
}

public protocol ProfileScreenDelegate: class {
    func mentionTapped()
    func hireTapped()
    func editTapped()
    func inviteTapped()
}

public class ProfileScreen: StreamableScreen, ProfileScreenProtocol {

    public struct Size {
        static let whiteTopOffset: CGFloat = 338
        static let rcControlsViewHeight: CGFloat = 60
        static let gradientHeight: CGFloat = 50
        static let navBarHeight: CGFloat = 64
        static let buttonMargin: CGFloat = 15
        static let buttonHeight: CGFloat = 30
        static let mentionButtonWidth: CGFloat = 100
        static let rcMaxWidth: CGFloat = 283
        static let rcLeadingMargin: CGFloat = 10
        static let editButtonMargin: CGFloat = 10
    }

    weak public var relationshipDelegate: RelationshipDelegate? {
        get { return self.relationshipControl.relationshipDelegate }
        set { self.relationshipControl.relationshipDelegate = newValue }
    }

    public var navBar: ElloNavigationBar {
        get { return self.navigationBar }
    }

    // views
    let whiteSolidView = UIView()
    let loaderView = InterpolatedLoadingView()
    public let coverImage = FLAnimatedImageView()
    public let relationshipControl = RelationshipControl()
    public let mentionButton = ElloMentionButton()
    public let hireButton = ElloHireButton()
    public let editButton = ElloEditProfileButton()
    public let inviteButton = ElloInviteButton()
    public let gradientView = UIView()
    public let gradientLayer = CAGradientLayer()
    public let relationshipControlsView = UIVisualEffectView()

    // constraints
    public private(set) var whiteSolidTop: NSLayoutConstraint!
    public private(set) var coverImageHeight: NSLayoutConstraint!
    public private(set) var gradientViewTopConstraint: NSLayoutConstraint!
    public private(set) var relationshipControlsViewTopConstraint: NSLayoutConstraint!


    weak public var delegate: ProfileScreenDelegate?

    override func arrange() {
        super.arrange()
        addSubview(loaderView)
        addSubview(coverImage)
        addSubview(whiteSolidView)
        addSubview(streamContainer)
        addSubview(gradientView)
        addSubview(relationshipControlsView)
        addSubview(navigationBar)

        // relationship controls sub views
        relationshipControlsView.addSubview(mentionButton)
        relationshipControlsView.addSubview(hireButton)
        relationshipControlsView.addSubview(inviteButton)
        relationshipControlsView.addSubview(relationshipControl)
        relationshipControlsView.addSubview(editButton)


        loaderView.snp_makeConstraints { make in
            make.edges.equalTo(self.coverImage)
        }

        coverImage.snp_makeConstraints { make in
            let c = make.height.equalTo(Size.whiteTopOffset).constraint
            self.coverImageHeight = c.layoutConstraints.first!
            make.width.equalTo(self.coverImage.snp_height).multipliedBy(ProfileHeaderCellSizeCalculator.ratio)
            make.top.equalTo(self.streamContainer.snp_top)
            make.centerX.equalTo(self)
        }

        whiteSolidView.snp_makeConstraints { make in
            let c = make.top.equalTo(self).offset(Size.whiteTopOffset).constraint
            self.whiteSolidTop = c.layoutConstraints.first!
            make.leading.trailing.bottom.equalTo(self)
        }

        gradientView.snp_makeConstraints { make in
            let c = make.top.equalTo(self).constraint
            self.gradientViewTopConstraint = c.layoutConstraints.first!
            make.height.equalTo(Size.gradientHeight)
            make.centerX.equalTo(self)
            make.width.equalTo(self)
        }

        relationshipControlsView.snp_makeConstraints { make in
            let c = make.top.equalTo(self).constraint
            self.relationshipControlsViewTopConstraint = c.layoutConstraints.first!
            make.centerX.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(Size.rcControlsViewHeight)
        }

        mentionButton.snp_makeConstraints { make in
            make.leading.equalTo(self.relationshipControlsView).offset(Size.buttonMargin)
            make.width.equalTo(Size.mentionButtonWidth).priorityMedium()
            make.width.greaterThanOrEqualTo(Size.mentionButtonWidth)
            make.height.equalTo(Size.buttonHeight)
            make.bottom.equalTo(self.relationshipControlsView).offset(-Size.buttonMargin)
        }

        hireButton.snp_makeConstraints { make in
            make.height.equalTo(Size.buttonHeight)
            make.leading.equalTo(self.mentionButton.snp_leading)
            make.top.equalTo(self.mentionButton)
            make.width.equalTo(self.mentionButton)
        }

        inviteButton.snp_makeConstraints { make in
            make.leading.equalTo(self.relationshipControlsView).offset(Size.buttonMargin)
            make.width.equalTo(Size.mentionButtonWidth).priorityMedium()
            make.width.greaterThanOrEqualTo(Size.mentionButtonWidth)
            make.height.equalTo(Size.buttonHeight)
            make.bottom.equalTo(self.relationshipControlsView).offset(-Size.buttonMargin)
        }

        relationshipControl.snp_makeConstraints { make in
            make.height.equalTo(Size.buttonHeight)
            make.width.lessThanOrEqualTo(Size.rcMaxWidth)
            make.leading.equalTo(self.mentionButton.snp_trailing).offset(Size.rcLeadingMargin)
            make.bottom.equalTo(self.relationshipControlsView).offset(-Size.buttonMargin)
            make.trailing.equalTo(self.relationshipControlsView).offset(-Size.buttonMargin)
        }

        editButton.snp_makeConstraints { make in
            make.height.equalTo(Size.buttonHeight)
            make.width.lessThanOrEqualTo(Size.rcMaxWidth)
            make.leading.equalTo(self.inviteButton.snp_trailing).offset(Size.editButtonMargin)
            make.trailing.equalTo(self.relationshipControlsView).offset(-Size.editButtonMargin)
            make.bottom.equalTo(-Size.buttonMargin)
        }

        layoutIfNeeded()
    }

    override func setText() {
    }

    override func style() {
        relationshipControl.style = .ProfileView
        relationshipControlsView.effect = UIBlurEffect(style: .Light)
        setupGradient()
    }

    override func bindActions() {
        mentionButton.addTarget(self, action: #selector(mentionTapped(_:)), forControlEvents: .TouchUpInside)
        hireButton.addTarget(self, action: #selector(hireTapped(_:)), forControlEvents: .TouchUpInside)
        editButton.addTarget(self, action: #selector(editTapped(_:)), forControlEvents: .TouchUpInside)
        inviteButton.addTarget(self, action: #selector(inviteTapped(_:)), forControlEvents: .TouchUpInside)
    }

    public func mentionTapped(button: UIButton) {
        delegate?.mentionTapped()
    }

    public func hireTapped(button: UIButton) {
        delegate?.hireTapped()
    }

    public func editTapped(button: UIButton) {
        delegate?.editTapped()
    }

    public func inviteTapped(button: UIButton) {
        delegate?.inviteTapped()
    }

    public func enableButtons() {
        setButtonsEnabled(true)
    }

    public func disableButtons() {
        setButtonsEnabled(false)
    }

    public func configureButtonsForNonCurrentUser(isHireable: Bool) {
        hireButton.hidden = !isHireable
        mentionButton.hidden = isHireable
        relationshipControl.hidden = false
        editButton.hidden = true
        inviteButton.hidden = true
    }

    public func configureButtonsForCurrentUser() {
        hireButton.hidden = true
        mentionButton.hidden = true
        relationshipControl.hidden = true
        editButton.hidden = false
        inviteButton.hidden = false
    }

    private func setButtonsEnabled(enabled: Bool) {
        hireButton.enabled = enabled
        mentionButton.enabled = enabled
        editButton.enabled = enabled
        inviteButton.enabled = enabled
        relationshipControl.enabled = enabled
    }

    public func updateGradientViewConstraint(contentOffset: CGPoint, navBarsVisible: Bool) {
        let additional: CGFloat = navBarsVisible ? navigationBar.frame.height : 0
        let constant: CGFloat

        if contentOffset.y < 0 {
            constant = 0
        }
        else if contentOffset.y > 45 {
            constant = -45
        }
        else {
            constant = -contentOffset.y
        }
        gradientViewTopConstraint.constant = constant + additional
    }

    public func resetCoverImage() {
        coverImage.pin_cancelImageDownload()
        coverImage.image = nil
    }

    public func showNavBars(offset: CGPoint) {
        animate {
            self.updateGradientViewConstraint(offset, navBarsVisible:false)
            self.relationshipControlsViewTopConstraint.constant = self.navBar.frame.height
            self.relationshipControlsView.frame.origin.y = self.relationshipControlsViewTopConstraint.constant
            self.gradientView.frame.origin.y = self.gradientViewTopConstraint.constant
        }
    }

    public func hideNavBars(offset: CGPoint, isCurrentUser: Bool) {
        animate {
            self.updateGradientViewConstraint(offset, navBarsVisible: false)
            if isCurrentUser {
                self.relationshipControlsViewTopConstraint.constant = -self.relationshipControlsView.frame.height
            }
            else {
                self.relationshipControlsViewTopConstraint.constant = 0
            }

            self.relationshipControlsView.frame.origin.y = self.relationshipControlsViewTopConstraint.constant
            self.gradientView.frame.origin.y = self.gradientViewTopConstraint.constant
        }
    }
}

extension ProfileScreen {

    private func setupGradient() {
        gradientLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: gradientView.frame.width,
            height: gradientView.frame.height
        )
        gradientLayer.locations = [0, 0.8, 1]
        gradientLayer.colors = [
            UIColor.whiteColor().CGColor,
            UIColor.whiteColor().colorWithAlphaComponent(0.5).CGColor,
            UIColor.whiteColor().colorWithAlphaComponent(0).CGColor,
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientView.layer.addSublayer(gradientLayer)
    }
}
