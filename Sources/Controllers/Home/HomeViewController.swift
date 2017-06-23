////
///  HomeViewController.swift
//


class HomeViewController: BaseElloViewController, HomeScreenDelegate {
    override func trackerName() -> String? { return visibleViewController?.trackerName() }
    override func trackerProps() -> [String: Any]? { return visibleViewController?.trackerProps() }

    fileprivate var visibleViewController: UIViewController?
    fileprivate var followingViewController: FollowingViewController!
    fileprivate var editorialsViewController: EditorialsViewController!

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

    override func didSetCurrentUser() {
        super.didSetCurrentUser()
        for controller in childViewControllers {
            guard let controller = controller as? ControllerThatMightHaveTheCurrentUser else { continue }
            controller.currentUser = currentUser
        }
    }

    override func loadView() {
        let screen = HomeScreen()
        screen.delegate = self

        self.view = screen
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupControllers()
    }

}

extension HomeViewController: HomeResponder {
    func showEditorialsViewController() {
        showController(editorialsViewController)
    }

    func showFollowingViewController() {
        showController(followingViewController)
    }

    fileprivate func setupControllers() {
        let editorialsViewController = EditorialsViewController(usage: .loggedIn)
        editorialsViewController.currentUser = currentUser
        addChildViewController(editorialsViewController)
        editorialsViewController.didMove(toParentViewController: self)
        self.editorialsViewController = editorialsViewController

        let followingViewController = FollowingViewController()
        followingViewController.currentUser = currentUser
        addChildViewController(followingViewController)
        followingViewController.didMove(toParentViewController: self)
        self.followingViewController = followingViewController

        showController(editorialsViewController)
    }

    fileprivate func showController(_ viewController: UIViewController) {
        if let visibleViewController = visibleViewController {
            viewController.trackScreenAppeared()

            screen.controllerContainer.insertSubview(viewController.view, aboveSubview: visibleViewController.view)
            visibleViewController.view.removeFromSuperview()
        }
        else {
            screen.controllerContainer.addSubview(viewController.view)
        }

        viewController.view.frame = screen.controllerContainer.bounds
        viewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        visibleViewController = viewController
    }

}

let drawerAnimator = DrawerAnimator()

extension HomeViewController: DrawerResponder {

    func showDrawerViewController() {
        let drawer = DrawerViewController()
        drawer.currentUser = currentUser

        drawer.transitioningDelegate = drawerAnimator
        drawer.modalPresentationStyle = .custom

        self.present(drawer, animated: true, completion: nil)
    }

}
