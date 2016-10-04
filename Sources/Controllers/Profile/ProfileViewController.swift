////
///  ProfileViewController.swift
//

import FLAnimatedImage


public final class ProfileViewController: StreamableViewController {

    override public var tabBarItem: UITabBarItem? {
        get { return UITabBarItem.item(.Person) }
        set { self.tabBarItem = newValue }
    }

    var _mockScreen: ProfileScreenProtocol?
    public var screen: ProfileScreenProtocol {
        set(screen) { _mockScreen = screen }
        get { return _mockScreen ?? self.view as! ProfileScreen }
    }
    public var profileScreen: ProfileScreen!


    var user: User?
    var headerItems: [StreamCellItem]?
    var responseConfig: ResponseConfig?
    var userParam: String!
    var coverImageHeightStart: CGFloat?
    let initialStreamKind: StreamKind
    var currentUserChangedNotification: NotificationObserver?
    var postChangedNotification: NotificationObserver?
    var relationshipChangedNotification: NotificationObserver?
    var deeplinkPath: String?
    var generator: ProfileGenerator?
    private var isSetup = false

    public init(userParam: String, username: String? = nil) {
        self.userParam = userParam
        self.initialStreamKind = .UserStream(userParam: self.userParam)
        super.init(nibName: nil, bundle: nil)

        if let username = username {
            title = "@\(username)"
        }

        if self.user == nil {
            if let user = ElloLinkedStore.sharedInstance.getObject(self.userParam,
               inCollection: MappingType.UsersType.rawValue) as? User {
                self.user = user
            }
        }

        sharedInit()

        relationshipChangedNotification = NotificationObserver(notification: RelationshipChangedNotification) { [unowned self] user in
            if self.user?.id == user.id {
                self.updateRelationshipPriority(user.relationshipPriority)
            }
        }
    }

    // this should only be initialized this way for currentUser in tab nav
    public init(user: User) {
        // this user must have the profile property assigned (since it is currentUser)
        self.user = user
        self.userParam = user.id
        self.initialStreamKind = .CurrentUserStream
        super.init(nibName: nil, bundle: nil)

        sharedInit()
        currentUserChangedNotification = NotificationObserver(notification: CurrentUserChangedNotification) { [unowned self] _ in
            self.updateCachedImages()
        }
    }

    private func sharedInit() {
        streamViewController.streamKind = initialStreamKind
        streamViewController.initialLoadClosure = { [unowned self] in self.loadProfile() }
        streamViewController.reloadClosure = { [unowned self] in self.reloadEntireProfile() }
        streamViewController.toggleClosure = { [unowned self] isGridView in self.toggleGrid(isGridView) }
    }

    deinit {
        currentUserChangedNotification?.removeObserver()
        currentUserChangedNotification = nil
        postChangedNotification?.removeObserver()
        postChangedNotification = nil
        relationshipChangedNotification?.removeObserver()
        relationshipChangedNotification = nil
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        if user == nil {
            screen.disableButtons()
        }

        self.generator = ProfileGenerator(
            currentUser: self.currentUser,
            userParam: userParam,
            user: self.user,
            streamKind: self.streamViewController.streamKind,
            destination: self
        )
        view.clipsToBounds = true
        setupNavigationBar()
        scrollLogic.prevOffset = streamViewController.collectionView.contentOffset
        ElloHUD.showLoadingHudInView(streamViewController.view)
        streamViewController.loadInitialPage()
        screen.relationshipDelegate = streamViewController.dataSource.relationshipDelegate

        if let user = user {
            updateUser(user)
        }
    }

    override public func loadView() {
        profileScreen = ProfileScreen()
        self.view = profileScreen
        viewContainer = profileScreen.streamContainer
        profileScreen.delegate = self
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let ratio: CGFloat = ProfileHeaderCellSizeCalculator.ratio
        let height: CGFloat = view.frame.width / ratio
        let maxHeight = height - streamViewController.collectionView.contentOffset.y
        let constant = max(maxHeight, height)
        if let ps = self.view as? ProfileScreen {
            ps.coverImageHeight.constant = constant
            ps.whiteSolidTop.constant = max(maxHeight, 0)
        }

        coverImageHeightStart = maxHeight

        if let ps = self.view as? ProfileScreen {
            ps.gradientLayer.frame.size = ps.gradientView.frame.size
        }

    }

    override public func didSetCurrentUser() {
        generator?.currentUser = currentUser
        super.didSetCurrentUser()
    }

    override func showNavBars(scrollToBottom: Bool) {
        super.showNavBars(scrollToBottom)
        guard let ps = self.view as? ProfileScreen else { return }
        positionNavBar(ps.navBar, visible: true, withConstraint: ps.navigationBarTopConstraint)
        updateInsets()

        if scrollToBottom {
            self.scrollToBottom(streamViewController)
        }

        let offset = self.streamViewController.collectionView.contentOffset
        ps.showNavBars(offset)
    }

    override func hideNavBars() {
        super.hideNavBars()
        hideNavBar(animated: true)
        updateInsets()

        guard let ps = self.view as? ProfileScreen else { return }
        let offset = self.streamViewController.collectionView.contentOffset
        let currentUser = (self.user?.id == self.currentUser?.id && self.user?.id != nil)
        ps.hideNavBars(offset, isCurrentUser: currentUser)
    }


    private func updateInsets() {
        guard let ps = self.screen as? ProfileScreen else { return }
        updateInsets(navBar: ps.relationshipControlsView, streamController: streamViewController)
    }

    private func hideNavBar(animated animated: Bool) {
        if let ps = self.view as? ProfileScreen {
            positionNavBar(screen.navBar, visible: false, withConstraint: ps.navigationBarTopConstraint, animated: animated)
        }
    }

    // MARK : private

    private func loadProfile() {
        generator?.load()
    }

    private func reloadEntireProfile() {
        screen.resetCoverImage()
        generator?.load(reload: true)
    }

    private func showUserLoadFailure() {
        let message = InterfaceString.GenericError
        let alertController = AlertViewController(message: message)
        let action = AlertAction(title: InterfaceString.OK, style: .Dark) { _ in
            self.navigationController?.popViewControllerAnimated(true)
        }
        alertController.addAction(action)
        logPresentingAlert("ProfileViewController")
        presentViewController(alertController, animated: true, completion: nil)
    }

    private func setupNavigationBar() {
        navigationController?.navigationBarHidden = true
        screen.navBar.items = [elloNavigationItem]
        if !isRootViewController() {
            let item = UIBarButtonItem.backChevronWithTarget(self, action: #selector(StreamableViewController.backTapped(_:)))
            self.elloNavigationItem.leftBarButtonItems = [item]
            self.elloNavigationItem.fixNavBarItemPadding()
        }
        assignRightButtons()
    }

    func assignRightButtons() {

        if let currentUser = currentUser where userParam == currentUser.id || userParam == "~\(currentUser.username)" {
            elloNavigationItem.rightBarButtonItems = [
                UIBarButtonItem(image: .Search, target: self, action: #selector(BaseElloViewController.searchButtonTapped)),
            ]
            return
        }

        guard let user = user else {
            elloNavigationItem.rightBarButtonItems = []
            return
        }

        if let currentUser = currentUser where user.id == currentUser.id {
            elloNavigationItem.rightBarButtonItems = []
            return
        }

        var rightBarButtonItems: [UIBarButtonItem] = []
        if user.hasSharingEnabled {
            rightBarButtonItems.append(UIBarButtonItem(image: .Share, target: self, action: #selector(ProfileViewController.sharePostTapped(_:))))
        }
        rightBarButtonItems.append(UIBarButtonItem(image: .Dots, target: self, action: #selector(ProfileViewController.moreButtonTapped)))

        guard elloNavigationItem.rightBarButtonItems != nil else {
            elloNavigationItem.rightBarButtonItems = rightBarButtonItems
            return
        }

        if !elloNavigationItem.areRightButtonsTheSame(rightBarButtonItems) {
            elloNavigationItem.rightBarButtonItems = rightBarButtonItems
        }
    }

    func moreButtonTapped() {
        guard let user = user else { return }

        let userId = user.id
        let userAtName = user.atName
        let prevRelationshipPriority = user.relationshipPriority
        streamViewController.relationshipController?.launchBlockModal(userId, userAtName: userAtName, relationshipPriority: prevRelationshipPriority) { newRelationshipPriority in
            user.relationshipPriority = newRelationshipPriority
        }
    }

    func sharePostTapped(sourceView: UIView) {
        guard let user = user,
            shareLink = user.shareLink,
            shareURL = NSURL(string: shareLink)
        else { return }

        Tracker.sharedTracker.userShared(user)
        let activityVC = UIActivityViewController(activityItems: [shareURL], applicationActivities: [SafariActivity()])
        if UI_USER_INTERFACE_IDIOM() == .Phone {
            activityVC.modalPresentationStyle = .FullScreen
            logPresentingAlert(readableClassName() ?? "ProfileViewController")
            presentViewController(activityVC, animated: true) { }
        }
        else {
            activityVC.modalPresentationStyle = .Popover
            activityVC.popoverPresentationController?.sourceView = sourceView
            logPresentingAlert(readableClassName() ?? "ProfileViewController")
            presentViewController(activityVC, animated: true) { }
        }
    }

    func toggleGrid(isGridView: Bool) {
        generator?.toggleGrid()
    }

}

extension ProfileViewController: ProfileScreenDelegate {
    public func mentionTapped() {
        guard let user = user else { return }

        createPost(text: "\(user.atName) ", fromController: self)
    }

    public func hireTapped() {
        guard let user = user else { return }

        Tracker.sharedTracker.tappedHire(user)
        let vc = HireViewController(user: user)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    public func editTapped() {
        onEditProfile()
    }

    public func inviteTapped() {
        onInviteFriends()
    }

    public func collaborateTapped() {
        guard let user = user else { return }

        Tracker.sharedTracker.tappedCollaborate(user)
        fatalError("HireViewController needs to support collaborate (and maybe be renamed)")
        let vc = HireViewController(user: user)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Check for cached coverImage and avatar (only for currentUser)
extension ProfileViewController {
    public func cachedImage(key: CacheKey) -> UIImage? {
        guard user?.id == currentUser?.id else {
            return nil
        }
        return TemporaryCache.load(key)
    }

    public func updateCachedImages() {
        guard let ps = self.view as? ProfileScreen else { return }

        guard let cachedImage = cachedImage(.CoverImage) else {
            return
        }

        // this seemingly unecessary nil check is an attempt
        // to guard against crash #6:
        // https://www.crashlytics.com/ello/ios/apps/co.ello.ello/issues/55725749f505b5ccf00cf76d/sessions/55725654012a0001029d613137326264
        ps.coverImage.image = cachedImage
    }

    public func updateUser(user: User) {
        screen.enableButtons()

        guard user.id == self.currentUser?.id else {
            screen.configureButtonsForNonCurrentUser(user.isHireable, isCollaborateable: user.isCollaborateable)
            return
        }

        // only update the avatar and coverImage assets if there is nothing
        // in the cache.  If images are in the cache, that implies that the
        // image could still be unprocessed, so don't set the avatar or
        // coverImage to the old, stale value.
        if cachedImage(.Avatar) == nil {
            self.currentUser?.avatar = user.avatar
        }

        if cachedImage(.CoverImage) == nil {
            self.currentUser?.coverImage = user.coverImage
        }

        elloNavigationItem.rightBarButtonItem = nil

        screen.configureButtonsForCurrentUser()
    }

    public func updateRelationshipPriority(relationshipPriority: RelationshipPriority) {
        guard let ps = self.view as? ProfileScreen else { return }
        ps.relationshipControl.relationshipPriority = relationshipPriority
        self.user?.relationshipPriority = relationshipPriority
    }
}

// MARK: ProfileViewController: PostsTappedResponder
extension ProfileViewController: PostsTappedResponder {
    public func onPostsTapped() {
        let indexPath = NSIndexPath(forItem: 1, inSection: 0)
        guard streamViewController.dataSource.isValidIndexPath(indexPath) else { return }
        streamViewController.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Top, animated: true)
    }
}

// MARK: ProfileViewController: EditProfileResponder
extension ProfileViewController: EditProfileResponder {
    public func onEditProfile() {
        guard let settings = UIStoryboard(name: "Settings", bundle: .None).instantiateInitialViewController() as? SettingsContainerViewController else { return }
        settings.currentUser = currentUser
        navigationController?.pushViewController(settings, animated: true)
    }
}

// MARK: ProfileViewController: StreamViewDelegate
extension ProfileViewController {

    override public func streamViewDidScroll(scrollView: UIScrollView) {
        if let ps = self.view as? ProfileScreen {
            if let start = coverImageHeightStart {
                ps.coverImageHeight.constant = max(start - scrollView.contentOffset.y, start)
                ps.whiteSolidTop.constant = max(start - scrollView.contentOffset.y, 0)
            }
            let offset = streamViewController.collectionView.contentOffset
            ps.updateGradientViewConstraint(offset, navBarsVisible: navBarsVisible())
        }
        super.streamViewDidScroll(scrollView)
    }
}

// MARK: ProfileViewController: StreamDestination
extension ProfileViewController:  StreamDestination {

    public var pagingEnabled: Bool {
        get { return streamViewController.pagingEnabled }
        set { streamViewController.pagingEnabled = newValue }
    }

    public func replacePlaceholder(type: StreamCellType.PlaceholderType, @autoclosure items: () -> [StreamCellItem], completion: ElloEmptyCompletion) {
        streamViewController.replacePlaceholder(type, with: items, completion: completion)
    }

    public func setPlaceholders(items: [StreamCellItem]) {
        streamViewController.clearForInitialLoad()
        streamViewController.appendUnsizedCellItems(items, withWidth: view.frame.width) { _ in }
        assignRightButtons()
    }

    public func setPrimaryJSONAble(jsonable: JSONAble) {
        guard let user = jsonable as? User else { return }

        self.user = user
        updateUser(user)

        userParam = user.id
        title = user.atName

        assignRightButtons()
        Tracker.sharedTracker.profileLoaded(user.atName ?? "(no name)")

        guard let ps = self.view as? ProfileScreen else { return }

        ps.relationshipControl.userId = user.id
        ps.relationshipControl.userAtName = user.atName
        ps.relationshipControl.relationshipPriority = user.relationshipPriority

        if let cachedImage = cachedImage(.CoverImage) {
            ps.coverImage.image = cachedImage
        }
        else if let
            cover = user.coverImageURL(viewsAdultContent: currentUser?.viewsAdultContent, animated: true)
        {
            ps.coverImage.pin_setImageFromURL(cover) { result in }
        }
    }

    public func setPagingConfig(responseConfig: ResponseConfig) {
        streamViewController.responseConfig = responseConfig
    }

    public func primaryJSONAbleNotFound() {
        if let deeplinkPath = self.deeplinkPath,
            deeplinkURL = NSURL(string: deeplinkPath)
        {
            UIApplication.sharedApplication().openURL(deeplinkURL)
            self.deeplinkPath = nil
            self.navigationController?.popViewControllerAnimated(true)
        }
        else {
            self.showUserLoadFailure()
        }
        self.streamViewController.doneLoading()
    }
}
