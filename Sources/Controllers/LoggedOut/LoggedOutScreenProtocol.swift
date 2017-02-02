////
///  LoggedOutScreenProtocol.swift
//

protocol LoggedOutProtocol: class {
    func showLoginScreen()
    func showJoinScreen()
}

protocol LoggedOutScreenProtocol: class {
    var bottomBarHeight: CGFloat { get }
    var bottomBarView: UIView { get }
    var delegate: LoggedOutProtocol? { get }
    func setControllerView(_ childView: UIView)
    func showJoinText()
}
