////
///  ProfileScreen.swift
//

import SnapKit


public class ProfileScreen: StreamableScreen, ProfileScreenProtocol {

    public struct Size {
        static let whiteTopOffset: CGFloat = 338
        static let profileButtonsContainerViewHeight: CGFloat = 64
        static let navBarHeight: CGFloat = 64
        static let buttonMargin: CGFloat = 15
        static let innerButtonMargin: CGFloat = 5
        static let buttonHeight: CGFloat = 30
        static let buttonWidth: CGFloat = 70
        static let mentionButtonWidth: CGFloat = 100
        static let relationshipButtonMaxWidth: CGFloat = 283
        static let relationshipControlLeadingMargin: CGFloat = 5
        static let editButtonMargin: CGFloat = 10
    }

    weak public var relationshipDelegate: RelationshipDelegate? {
        get { return self.relationshipControl.relationshipDelegate }
        set { self.relationshipControl.relationshipDelegate = newValue }
    }

    public var coverImage: UIImage? {
        get { return coverImageView.image }
        set { coverImageView.image = newValue }
    }

    public var coverImageURL: NSURL? {
        get { return nil }
        set { coverImageView.pin_setImageFromURL(newValue) { result in } }
    }

    // views
    let whiteSolidView = UIView()
    let loaderView = InterpolatedLoadingView()
    public let coverImageView = FLAnimatedImageView()
    public let relationshipControl = RelationshipControl()
    public let mentionButton = StyledButton(style: .BlackPill)
    public let collaborateButton = StyledButton(style: .BlackPill)
    public let hireButton = StyledButton(style: .BlackPill)
    public let editButton = StyledButton(style: .BlackPill)
    public let inviteButton = StyledButton(style: .BlackPill)
    public let ghostLeftButton = StyledButton(style: .BlackPill)
    public let ghostRightButton = StyledButton(style: .BlackPill)
    public let profileButtonsEffect = UIVisualEffectView()
    public var profileButtonsContainer: UIView { return profileButtonsEffect.contentView }

    // constraints
    private var whiteSolidTop: Constraint!
    private var coverImageHeight: Constraint!
    private var profileButtonsContainerTopConstraint: Constraint!
    private var hireLeftConstraint: Constraint!
    private var hireRightConstraint: Constraint!
    private var relationshipMentionConstraint: Constraint!
    private var relationshipCollabConstraint: Constraint!
    private var relationshipHireConstraint: Constraint!

    weak public var delegate: ProfileScreenDelegate?

    override func arrange() {
        super.arrange()
        addSubview(loaderView)
        addSubview(coverImageView)
        addSubview(whiteSolidView)
        addSubview(streamContainer)
        addSubview(profileButtonsEffect)
        addSubview(navigationBar)

        // relationship controls sub views
        profileButtonsContainer.addSubview(mentionButton)
        profileButtonsContainer.addSubview(collaborateButton)
        profileButtonsContainer.addSubview(hireButton)
        profileButtonsContainer.addSubview(inviteButton)
        profileButtonsContainer.addSubview(relationshipControl)
        profileButtonsContainer.addSubview(editButton)
        profileButtonsContainer.addSubview(ghostLeftButton)
        profileButtonsContainer.addSubview(ghostRightButton)

        loaderView.snp_makeConstraints { make in
            make.edges.equalTo(coverImageView)
        }

        coverImageView.snp_makeConstraints { make in
            coverImageHeight = make.height.equalTo(Size.whiteTopOffset).constraint
            make.width.equalTo(coverImageView.snp_height).multipliedBy(ProfileHeaderCellSizeCalculator.ratio)
            make.top.equalTo(streamContainer.snp_top)
            make.centerX.equalTo(self)
        }

        whiteSolidView.snp_makeConstraints { make in
            whiteSolidTop = make.top.equalTo(self).offset(Size.whiteTopOffset).constraint
            make.leading.trailing.bottom.equalTo(self)
        }

        profileButtonsEffect.snp_makeConstraints { make in
            profileButtonsContainerTopConstraint = make.top.equalTo(self).constraint
            make.centerX.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(Size.profileButtonsContainerViewHeight)
        }

        mentionButton.snp_makeConstraints { make in
            make.leading.equalTo(profileButtonsContainer).offset(Size.buttonMargin)
            make.width.equalTo(Size.mentionButtonWidth).priorityRequired()
            make.height.equalTo(Size.buttonHeight)
            make.bottom.equalTo(profileButtonsContainer).offset(-Size.buttonMargin)
        }

        collaborateButton.snp_makeConstraints { make in
            make.height.equalTo(Size.buttonHeight)
            make.leading.equalTo(mentionButton.snp_leading).constraint
            make.top.equalTo(mentionButton)
            make.width.equalTo(Size.buttonWidth).priorityRequired()
        }

        hireButton.snp_makeConstraints { make in
            make.height.equalTo(Size.buttonHeight)
            hireLeftConstraint = make.leading.equalTo(mentionButton.snp_leading).constraint
            hireRightConstraint = make.leading.equalTo(collaborateButton.snp_trailing).offset(Size.innerButtonMargin).constraint
            make.top.equalTo(mentionButton)
            make.width.equalTo(Size.buttonWidth).priorityRequired()
        }
        hireLeftConstraint.uninstall()
        hireRightConstraint.uninstall()

        inviteButton.snp_makeConstraints { make in
            make.leading.equalTo(profileButtonsContainer).offset(Size.buttonMargin)
            make.width.equalTo(Size.mentionButtonWidth).priorityMedium()
            make.width.greaterThanOrEqualTo(Size.mentionButtonWidth)
            make.height.equalTo(Size.buttonHeight)
            make.bottom.equalTo(profileButtonsContainer).offset(-Size.buttonMargin)
        }

        relationshipControl.snp_makeConstraints { make in
            make.height.equalTo(Size.buttonHeight)
            make.width.lessThanOrEqualTo(Size.relationshipButtonMaxWidth).priorityRequired()
            relationshipMentionConstraint = make.leading.equalTo(mentionButton.snp_trailing).offset(Size.relationshipControlLeadingMargin).priorityMedium().constraint
            relationshipCollabConstraint = make.leading.equalTo(collaborateButton.snp_trailing).offset(Size.relationshipControlLeadingMargin).priorityMedium().constraint
            relationshipHireConstraint = make.leading.equalTo(hireButton.snp_trailing).offset(Size.relationshipControlLeadingMargin).priorityMedium().constraint
            make.bottom.equalTo(profileButtonsContainer).offset(-Size.buttonMargin)
            make.trailing.equalTo(profileButtonsContainer).offset(-Size.buttonMargin).priorityRequired()
        }
        relationshipMentionConstraint.uninstall()
        relationshipCollabConstraint.uninstall()
        relationshipHireConstraint.uninstall()

        editButton.snp_makeConstraints { make in
            make.height.equalTo(Size.buttonHeight)
            make.width.lessThanOrEqualTo(Size.relationshipButtonMaxWidth)
            make.leading.equalTo(inviteButton.snp_trailing).offset(Size.editButtonMargin)
            make.trailing.equalTo(profileButtonsContainer).offset(-Size.editButtonMargin)
            make.bottom.equalTo(-Size.buttonMargin)
        }

        ghostLeftButton.snp_makeConstraints { make in
            make.leading.equalTo(profileButtonsContainer).offset(Size.buttonMargin)
            make.width.equalTo(Size.mentionButtonWidth).priorityRequired()
            make.height.equalTo(Size.buttonHeight)
            make.bottom.equalTo(profileButtonsContainer).offset(-Size.buttonMargin)
        }

        ghostRightButton.snp_makeConstraints { make in
            make.height.equalTo(Size.buttonHeight)
            make.width.lessThanOrEqualTo(Size.relationshipButtonMaxWidth)
            make.leading.equalTo(ghostLeftButton.snp_trailing).offset(Size.editButtonMargin)
            make.trailing.equalTo(profileButtonsContainer).offset(-Size.editButtonMargin)
            make.bottom.equalTo(-Size.buttonMargin)
        }
    }

    override func setText() {
        collaborateButton.setTitle(InterfaceString.Profile.Collaborate, forState: .Normal)
        hireButton.setTitle(InterfaceString.Profile.Hire, forState: .Normal)
        inviteButton.setTitle(InterfaceString.Profile.Invite, forState: .Normal)
        editButton.setTitle(InterfaceString.Profile.EditProfile, forState: .Normal)
        mentionButton.setTitle(InterfaceString.Profile.Mention, forState: .Normal)
    }

    override func style() {
        whiteSolidView.backgroundColor = .whiteColor()
        relationshipControl.style = .ProfileView
        profileButtonsEffect.effect = UIBlurEffect(style: .Light)
        coverImageView.contentMode = .ScaleAspectFill

        collaborateButton.hidden = true
        hireButton.hidden = true
        mentionButton.hidden = true
        relationshipControl.hidden = true
        editButton.hidden = true
        inviteButton.hidden = true
        ghostLeftButton.hidden = false
        ghostRightButton.hidden = false
        ghostLeftButton.enabled = false
        ghostRightButton.enabled = false
    }

    override func bindActions() {
        mentionButton.addTarget(self, action: #selector(mentionTapped(_:)), forControlEvents: .TouchUpInside)
        collaborateButton.addTarget(self, action: #selector(collaborateTapped(_:)), forControlEvents: .TouchUpInside)
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

    public func collaborateTapped(button: UIButton) {
        delegate?.collaborateTapped()
    }

    public func enableButtons() {
        setButtonsEnabled(true)
    }

    public func disableButtons() {
        setButtonsEnabled(false)
    }

    public func configureButtonsForNonCurrentUser(isHireable isHireable: Bool, isCollaborateable: Bool) {
        if isHireable && isCollaborateable {
            hireLeftConstraint.uninstall()
            hireRightConstraint.install()
        }
        else if isHireable {
            hireLeftConstraint.install()
            hireRightConstraint.uninstall()
        }
        else if isCollaborateable {
            hireLeftConstraint.install()
            hireRightConstraint.uninstall()
        }

        if isHireable {
            relationshipCollabConstraint.uninstall()
            relationshipHireConstraint.install()
            relationshipMentionConstraint.uninstall()
        }
        else if isCollaborateable {
            relationshipCollabConstraint.install()
            relationshipHireConstraint.uninstall()
            relationshipMentionConstraint.uninstall()
        }
        else {
            relationshipHireConstraint.uninstall()
            relationshipCollabConstraint.uninstall()
            relationshipMentionConstraint.install()
        }

        collaborateButton.hidden = !isCollaborateable
        hireButton.hidden = !isHireable
        mentionButton.hidden = isHireable || isCollaborateable
        relationshipControl.hidden = false
        editButton.hidden = true
        inviteButton.hidden = true
        ghostLeftButton.hidden = true
        ghostRightButton.hidden = true
    }

    public func configureButtonsForCurrentUser() {
        collaborateButton.hidden = true
        hireButton.hidden = true
        mentionButton.hidden = true
        relationshipControl.hidden = true
        editButton.hidden = false
        inviteButton.hidden = false
        ghostLeftButton.hidden = true
        ghostRightButton.hidden = true
    }

    private func setButtonsEnabled(enabled: Bool) {
        collaborateButton.enabled = enabled
        hireButton.enabled = enabled
        mentionButton.enabled = enabled
        editButton.enabled = enabled
        inviteButton.enabled = enabled
        relationshipControl.enabled = enabled
    }

    public func updateRelationshipControl(user user: User) {
        relationshipControl.userId = user.id
        relationshipControl.userAtName = user.atName
        relationshipControl.relationshipPriority = user.relationshipPriority
    }

    public func updateRelationshipPriority(relationshipPriority: RelationshipPriority) {
        relationshipControl.relationshipPriority = relationshipPriority
    }

    public func updateHeaderHeightConstraints(max maxHeaderHeight: CGFloat, scrollAdjusted scrollAdjustedHeight: CGFloat) {
        coverImageHeight.updateOffset(maxHeaderHeight)
        whiteSolidTop.updateOffset(max(scrollAdjustedHeight, 0))
    }

    public func resetCoverImage() {
        coverImageView.pin_cancelImageDownload()
        coverImageView.image = nil
    }

    public func showNavBars() {
        animate {
            let height = self.navigationBar.frame.height
            self.profileButtonsContainerTopConstraint.updateOffset(height)
            self.profileButtonsEffect.frame.origin.y = height
        }
    }

    public func hideNavBars(offset: CGPoint, isCurrentUser: Bool) {
        animate {
            let height: CGFloat
            if isCurrentUser {
                height = -self.profileButtonsEffect.frame.height
            }
            else {
                height = 0
            }

            self.profileButtonsContainerTopConstraint.updateOffset(height)
            self.profileButtonsEffect.frame.origin.y = height
        }
    }
}
