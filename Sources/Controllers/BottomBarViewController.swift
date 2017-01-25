////
///  BottomBarViewController.swift
//

protocol BottomBarable {
    var bottomBarVisible: Bool { get set }
    var bottomBarView: UIView { get }
    func setBottomBarVisible(_ visible: Bool, animated: Bool)
}

class BottomBarViewController: UIViewController, HasAppController, BottomBarable {
    var parentAppController: AppViewController?
    var bottomBarVisible: Bool = true
    var bottomBarView = UIView()
    func setBottomBarVisible(_ visible: Bool, animated: Bool) {
    }
}
