////
///  BaseElloViewController.swift
//

@objc public protocol ControllerThatMightHaveTheCurrentUser {
    var currentUser: User? { get set }
}

public class BaseElloViewController: UIViewController, ControllerThatMightHaveTheCurrentUser {

    public var elloNavigationItem = UINavigationItem()

    override public var title: String? {
        didSet {
            elloNavigationItem.title = title ?? ""
        }
    }

    public var currentUser: User? {
        didSet { didSetCurrentUser() }
    }

    var appViewController: AppViewController? {
        return findViewController { vc in vc is AppViewController } as? AppViewController
    }

    var elloTabBarController: ElloTabBarController? {
        return findViewController { vc in vc is ElloTabBarController } as? ElloTabBarController
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.fixNavBarItemPadding()
    }

    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }

    func didSetCurrentUser() {}

    @IBAction
    func backTapped() {
        guard
            let navigationController = navigationController
        where navigationController.childViewControllers.count > 1 else { return }

        navigationController.popViewControllerAnimated(true)
    }

    public func isRootViewController() -> Bool {
        if let viewControllers = navigationController?.viewControllers {
            return (viewControllers[0] ) == self
        }
        return false
    }
}

// MARK: Search
public extension BaseElloViewController {
    func searchButtonTapped() {
        let search = SearchViewController()
        search.currentUser = currentUser
        self.navigationController?.pushViewController(search, animated: true)
    }
}
