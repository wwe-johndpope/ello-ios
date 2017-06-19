////
///  HomeProtocols.swift
//

protocol HomeResponder: class {
    func showEditorialsViewController()
    func showFollowingViewController()
}

protocol HomeScreenDelegate: class {
}

protocol HomeScreenProtocol: class {
    var delegate: HomeScreenDelegate? { get set }
    var controllerContainer: UIView { get }
}
