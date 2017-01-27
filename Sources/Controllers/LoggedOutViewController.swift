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


class LoggedOutViewController: UIViewController, HasAppController, BottomBarController {

    struct Size {
        static let bottomBarHeight: CGFloat = 50
    }

    var parentAppController: AppViewController?
    var navigationBarsVisible: Bool = true
    let bottomBarVisible: Bool = true
    var bottomBarHeight: CGFloat { return Size.bottomBarHeight }
    let controllerView = UIView()
    let bottomBarView = UIView()
    func setNavigationBarsVisible(_ visible: Bool, animated: Bool) {
        navigationBarsVisible = visible
    }

    override func addChildViewController(_ childController: UIViewController) {
        super.addChildViewController(childController)
        controllerView.addSubview(childController.view)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for childController in childViewControllers {
            childController.view.frame = controllerView.bounds
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(controllerView)
        controllerView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        view.addSubview(bottomBarView)
        bottomBarView.backgroundColor = .green
        bottomBarView.snp.makeConstraints { make in
            make.bottom.trailing.leading.equalTo(view)
            make.height.equalTo(Size.bottomBarHeight)
        }
    }
}
