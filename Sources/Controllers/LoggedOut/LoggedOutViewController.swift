////
///  LoggedOutViewController.swift
//

import SnapKit


protocol BottomBarController: class {
    var navigationBarsVisible: Bool { get }
    var bottomBarVisible: Bool { get }
    var bottomBarHeight: CGFloat { get }
    var bottomBarView: UIView { get }
    func setNavigationBarsVisible(_ visible: Bool, animated: Bool)
}


class LoggedOutViewController: BaseElloViewController, BottomBarController {
    var navigationBarsVisible: Bool = true
    let bottomBarVisible: Bool = true
    var bottomBarHeight: CGFloat { return screen.bottomBarHeight }
    var bottomBarView: UIView { return screen.bottomBarView }

    var mockScreen: LoggedOutScreenProtocol?
    var screen: LoggedOutScreenProtocol { return mockScreen ?? (self.view as! LoggedOutScreenProtocol) }

    func setNavigationBarsVisible(_ visible: Bool, animated: Bool) {
        navigationBarsVisible = visible
    }

    override func addChildViewController(_ childController: UIViewController) {
        super.addChildViewController(childController)
        screen.setControllerView(childController.view)
    }

    override func loadView() {
        let screen = LoggedOutScreen()
        screen.delegate = self
        self.view = screen
    }
}

extension LoggedOutViewController: LoggedOutProtocol {
    func showLoginScreen() {
        appViewController?.showLoginScreen(animated: true)
    }

    func showJoinScreen() {
        appViewController?.showJoinScreen(animated: true)
    }
}
