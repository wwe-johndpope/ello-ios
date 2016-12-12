////
///  NotificationsViewController.swift
//


public class NotificationsViewController: StreamableViewController, NotificationDelegate, NotificationsScreenDelegate {
    var generator: NotificationsGenerator?
    var hasNewContent = false
    var fromTabBar = false
    private var reloadNotificationsObserver: NotificationObserver?
    private var newAnnouncementsObserver: NotificationObserver?
    public var categoryFilterType = NotificationFilterType.All
    public var categoryStreamKind: StreamKind { return .Notifications(category: categoryFilterType.category) }

    override public var tabBarItem: UITabBarItem? {
        get { return UITabBarItem.item(.Bolt) }
        set { self.tabBarItem = newValue }
    }

    override public func loadView() {
        self.view = NotificationsScreen(frame: UIScreen.mainScreen().bounds)
    }

    var screen: NotificationsScreen {
        return self.view as! NotificationsScreen
    }

    var navigationNotificationObserver: NotificationObserver?

    public init() {
        super.init(nibName: nil, bundle: nil)
        addNotificationObservers()

        generator = NotificationsGenerator(
            currentUser: currentUser,
            streamKind: categoryStreamKind,
            destination: self
        )
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        navigationNotificationObserver?.removeObserver()
        reloadNotificationsObserver?.removeObserver()
        newAnnouncementsObserver?.removeObserver()
    }

    override public func didSetCurrentUser() {
        generator?.currentUser = currentUser
        super.didSetCurrentUser()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        screen.delegate = self
        title = InterfaceString.Notifications.Title
        elloNavigationItem.rightBarButtonItem = UIBarButtonItem.searchItem(controller: self)

        scrollLogic.prevOffset = streamViewController.collectionView.contentOffset
        scrollLogic.navBarHeight = 44

        reload()
    }

    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if hasNewContent && fromTabBar {
            reload()
        }
        fromTabBar = false

        PushNotificationController.sharedController.updateBadgeNumber(0)
    }

    func initialLoad() {
        ElloHUD.showLoadingHudInView(streamViewController.view)
        generator?.load(reload: false)
    }

    func reload() {
        ElloHUD.showLoadingHudInView(streamViewController.view)
        hasNewContent = false

        generator?.streamKind = categoryStreamKind
        generator?.load(reload: true)
    }

    func reloadAnnouncements() {
        generator?.reloadAnnouncements()
    }

    override func setupStreamController() {
        super.setupStreamController()

        streamViewController.streamKind = categoryStreamKind
        streamViewController.announcementDelegate = self
        streamViewController.notificationDelegate = self
        streamViewController.initialLoadClosure = { [weak self] in self?.initialLoad() }
        streamViewController.reloadClosure = { [weak self] in self?.reload() }
    }

    override public func showNavBars(scrollToBottom: Bool) {
        super.showNavBars(scrollToBottom)
        screen.animateNavigationBar(visible: true)
        updateInsets()

        if scrollToBottom {
            self.scrollToBottom(streamViewController)
        }
    }

    override public func hideNavBars() {
        super.hideNavBars()
        screen.animateNavigationBar(visible: false)
        updateInsets()
    }


    // used to provide StreamableViewController access to the container it then
    // loads the StreamViewController's content into
    override func viewForStream() -> UIView {
        return self.screen.streamContainer
    }

    public func activatedCategory(filterTypeStr: String) {
        let filterType = NotificationFilterType(rawValue: filterTypeStr)!
        activatedCategory(filterType)
    }

    public func activatedCategory(filterType: NotificationFilterType) {
        screen.selectFilterButton(filterType)
        categoryFilterType = filterType

        streamViewController.streamKind = categoryStreamKind
        streamViewController.hideNoResults()
        streamViewController.removeAllCellItems()

        reload()
    }

    public func commentTapped(comment: ElloComment) {
        if let post = comment.loadedFromPost {
            postTapped(post)
        }
        else {
            postTapped(postId: comment.postId)
        }
    }

    public func respondToNotification(components: [String]) {
        var popToRoot: Bool = true
        if let path = components.safeValue(0) {
            switch path {
            case "posts":
                if let id = components.safeValue(1) {
                    popToRoot = false
                    postTapped(postId: id)
                }
            case "users":
                if let id = components.safeValue(1) {
                    popToRoot = false
                    userParamTapped(id, username: nil)
                }
            default:
                break
            }
        }

        if popToRoot {
            navigationController?.popToRootViewControllerAnimated(true)
        }

        reload()
    }

}

private extension NotificationsViewController {

    func addNotificationObservers() {
        navigationNotificationObserver = NotificationObserver(notification: NavigationNotifications.showingNotificationsTab) { [weak self] components in
            guard let sself = self else { return }
            sself.respondToNotification(components)
        }

        reloadNotificationsObserver = NotificationObserver(notification: NewContentNotifications.reloadNotifications) {
            [weak self] _ in
            guard let sself = self else { return }
            if sself.navigationController?.childViewControllers.count == 1 {
                sself.reload()
            }
            else {
                sself.hasNewContent = true
            }
        }

        newAnnouncementsObserver = NotificationObserver(notification: NewContentNotifications.newAnnouncements) {
            [weak self] _ in
            guard let sself = self else { return }
            sself.reloadAnnouncements()
        }
    }

    func updateInsets() {
        updateInsets(navBar: screen.filterBar, streamController: streamViewController)
    }
}

// MARK: NotificationsViewController: StreamDestination
extension NotificationsViewController: StreamDestination {

    public var pagingEnabled: Bool {
        get { return streamViewController.pagingEnabled }
        set { streamViewController.pagingEnabled = newValue }
    }

    public func replacePlaceholder(type: StreamCellType.PlaceholderType, items: [StreamCellItem], completion: ElloEmptyCompletion) {
        streamViewController.replacePlaceholder(type, with: items, completion: completion)
    }

    public func setPlaceholders(items: [StreamCellItem]) {
        streamViewController.clearForInitialLoad()
        streamViewController.appendUnsizedCellItems(items, withWidth: view.frame.width) { _ in }
    }

    public func setPrimaryJSONAble(jsonable: JSONAble) {
        self.streamViewController.doneLoading()
    }

    public func setPagingConfig(responseConfig: ResponseConfig) {
        streamViewController.responseConfig = responseConfig
    }

    public func primaryJSONAbleNotFound() {
        self.streamViewController.doneLoading()
    }
}

// MARK: NotificationsViewController:
extension NotificationsViewController: AnnouncementDelegate {
    public func markAnnouncementAsRead(_ announcement: Announcement) {
        generator?.markAnnouncementAsRead(announcement)
        postNotification(JSONAbleChangedNotification, value: (announcement, .Delete))
    }
}
