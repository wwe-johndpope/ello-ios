////
///  FollowingViewController.swift
//

import SnapKit
import SwiftyUserDefaults


class FollowingViewController: StreamableViewController {
    override func trackerName() -> String? { return "Stream" }
    override func trackerProps() -> [String: Any]? {
        return ["kind": "Following"]
    }
    override func trackerStreamInfo() -> (String, String?)? {
        return ("following", nil)
    }

    var navigationBar: ElloNavigationBar!
    let newPostsButton = NewPostsButton()
    fileprivate var loggedPromptEventForThisSession = false
    fileprivate var reloadFollowingContentObserver: NotificationObserver?
    fileprivate var appBackgroundObserver: NotificationObserver?
    fileprivate var appForegroundObserver: NotificationObserver?
    fileprivate var newFollowingContentObserver: NotificationObserver?

    override var tabBarItem: UITabBarItem? {
        get { return UITabBarItem.item(.following, insets: ElloTab.following.insets) }
        set { self.tabBarItem = newValue }
    }

    required init() {
        super.init(nibName: nil, bundle: nil)
        self.title = ""
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removeNotificationObservers()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupNavigationBar()
        setupNavigationItems(streamKind: .following)

        streamViewController.streamKind = .following
        ElloHUD.showLoadingHudInView(streamViewController.view)
        streamViewController.loadInitialPage()

        view.addSubview(newPostsButton)
        newPostsButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(NewPostsButton.Size.top)
        }
        newPostsButton.addTarget(self, action: #selector(loadNewPosts), for: .touchUpInside)
        newPostsButton.alpha = 0

        addNotificationObservers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        addTemporaryNotificationObservers()
        if !loggedPromptEventForThisSession {
            Rate.sharedRate.logEvent()
            loggedPromptEventForThisSession = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeTemporaryNotificationObservers()
    }

    override func viewForStream() -> UIView {
        return view
    }

    override func didSetCurrentUser() {
        if isViewLoaded {
            streamViewController.currentUser = currentUser
        }
        super.didSetCurrentUser()
    }

    override func showNavBars() {
        super.showNavBars()
        positionNavBar(navigationBar, visible: true)
        updateInsets()
    }

    override func hideNavBars() {
        super.hideNavBars()
        positionNavBar(navigationBar, visible: false)
        updateInsets()
    }

    // MARK: - IBActions
    let drawerAnimator = DrawerAnimator()

    func hamburgerButtonTapped() {
        let drawer = DrawerViewController()
        drawer.currentUser = currentUser

        drawer.transitioningDelegate = drawerAnimator
        drawer.modalPresentationStyle = .custom

        self.present(drawer, animated: true, completion: nil)
    }

    @objc
    func loadNewPosts() {
        let scrollView = streamViewController.collectionView
        scrollView.setContentOffset(CGPoint(x: 0, y: -scrollView.contentInset.top), animated: true)
        postNotification(NewContentNotifications.reloadFollowingContent, value: ())

        hideNewPostsButton(animated: true)
    }

    override func streamWillPullToRefresh() {
        super.streamWillPullToRefresh()

        hideNewPostsButton(animated: true)
    }

    func hideNewPostsButton(animated: Bool) {
        animate(animated: animated) {
            self.newPostsButton.alpha = 0
        }
    }

}

private extension FollowingViewController {

    func updateInsets() {
        updateInsets(navBar: navigationBar)
    }

    func setupNavigationBar() {
        navigationBar = ElloNavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: ElloNavigationBar.Size.height))
        navigationBar.autoresizingMask = [.flexibleBottomMargin, .flexibleWidth]
        view.addSubview(navigationBar)

    }

    func setupNavigationItems(streamKind: StreamKind) {
        elloNavigationItem.leftBarButtonItem = UIBarButtonItem(image: InterfaceImage.burger.normalImage, style: .done, target: self, action: #selector(FollowingViewController.hamburgerButtonTapped))
        let gridListItem = UIBarButtonItem.gridListItem(delegate: streamViewController, isGridView: streamKind.isGridView)
        elloNavigationItem.rightBarButtonItem = gridListItem
        navigationBar.items = [elloNavigationItem]
    }

    func addTemporaryNotificationObservers() {
        reloadFollowingContentObserver = NotificationObserver(notification: NewContentNotifications.reloadFollowingContent) { [weak self] in
            guard let `self` = self else { return }

            ElloHUD.showLoadingHudInView(self.streamViewController.view)
            self.hideNewPostsButton(animated: true)
            self.streamViewController.loadInitialPage(reload: true)
        }
    }

    func removeTemporaryNotificationObservers() {
        reloadFollowingContentObserver?.removeObserver()
    }

    func addNotificationObservers() {
        newFollowingContentObserver = NotificationObserver(notification: NewContentNotifications.newFollowingContent) { [weak self] in
            guard let `self` = self else { return }

            animate {
                self.newPostsButton.alpha = 1
            }
        }

        appBackgroundObserver = NotificationObserver(notification: Application.Notifications.DidEnterBackground) { [weak self] _ in
            self?.loggedPromptEventForThisSession = false
        }
    }

    func removeNotificationObservers() {
        newFollowingContentObserver?.removeObserver()
        appBackgroundObserver?.removeObserver()
    }
}
