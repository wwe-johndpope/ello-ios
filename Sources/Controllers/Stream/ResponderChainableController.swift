////
///  ResponderChainableController.swift
//

struct ResponderChainableController {
    weak var controller: UIViewController?
    var next: () -> UIResponder?
}
