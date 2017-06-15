////
///  HomeProtocols.swift
//

protocol HomeScreenDelegate: class {
}

protocol HomeScreenProtocol: class {
    var delegate: HomeScreenDelegate? { get set }
    var controllerContainer: UIView { get }
}
