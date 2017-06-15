////
///  HomeViewController.swift
//


class HomeViewController: BaseElloViewController, HomeScreenDelegate {
    override func trackerName() -> String? { return visibleViewController?.trackerName() }
    override func trackerProps() -> [String: Any]? { return visibleViewController?.trackerProps() }

    var visibleViewController: UIViewController?

    enum Controllers {
        case editorials
        case following
    }

    override var tabBarItem: UITabBarItem? {
        get { return UITabBarItem.item(.following, insets: ElloTab.following.insets) }
        set { self.tabBarItem = newValue }
    }

    private var _mockScreen: HomeScreenProtocol?
    var screen: HomeScreenProtocol {
        set(screen) { _mockScreen = screen }
        get { return _mockScreen ?? self.view as! HomeScreen }
    }

    override func loadView() {
        let screen = HomeScreen()
        screen.delegate = self

        self.view = screen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    fileprivate func setupControllers() {
        let c1 = embed(FollowingViewController())
        addChildViewController(c1)
        c1.didMove(toParentViewController: self)

        let c2 = embed(FollowingViewController())
        addChildViewController(c2)
        c2.didMove(toParentViewController: self)

        showController(c1)
    }

    fileprivate func embed(_ controller: UIViewController) -> UIViewController {
        let nav = ElloNavigationController(rootViewController: controller)
        nav.currentUser = currentUser
        return nav
    }

    fileprivate func showController(_ viewController: UIViewController) {
        if let visibleViewController = visibleViewController {
            viewController.trackScreenAppeared()

            visibleViewController.view.removeFromSuperview()
            screen.controllerContainer.insertSubview(viewController.view, aboveSubview: visibleViewController.view)
        }
        else {
            screen.controllerContainer.addSubview(viewController.view)
        }
        viewController.view.frame = screen.controllerContainer.bounds
        viewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        visibleViewController = viewController
    }

}
