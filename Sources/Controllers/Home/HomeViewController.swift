////
///  HomeViewController.swift
//


class HomeViewController: BaseElloViewController, HomeScreenDelegate {
    override func trackerName() -> String? { return visibleViewController?.trackerName() }
    override func trackerProps() -> [String: Any]? { return visibleViewController?.trackerProps() }

    fileprivate var visibleViewController: UIViewController?
    fileprivate var followingViewController: FollowingViewController!
    fileprivate var discoverViewController: CategoryViewController!
    fileprivate var editorialsViewController: EditorialsViewController!

    enum Usage {
        case loggedOut
        case loggedIn
    }

    enum Controllers {
        case editorials
        case following
        case discover
    }

    override var tabBarItem: UITabBarItem? {
        get { return UITabBarItem.item(.home, insets: ElloTab.home.insets) }
        set { self.tabBarItem = newValue }
    }

    fileprivate let usage: Usage

    init(usage: Usage) {
        self.usage = usage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    func showDiscoverViewController() {
        showController(discoverViewController)
    }

    fileprivate func setupControllers() {
        let editorialsViewController = EditorialsViewController(usage: usage)
        editorialsViewController.currentUser = currentUser
        addChildViewController(editorialsViewController)
        editorialsViewController.didMove(toParentViewController: self)
        self.editorialsViewController = editorialsViewController

        let followingViewController = FollowingViewController()
        followingViewController.currentUser = currentUser
        addChildViewController(followingViewController)
        followingViewController.didMove(toParentViewController: self)
        self.followingViewController = followingViewController

        let discoverViewController = CategoryViewController(slug: Category.featured.slug, name: Category.featured.name, usage: .largeNav)
        discoverViewController.category = Category.featured
        discoverViewController.currentUser = currentUser
        addChildViewController(discoverViewController)
        discoverViewController.didMove(toParentViewController: self)
        self.discoverViewController = discoverViewController

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
