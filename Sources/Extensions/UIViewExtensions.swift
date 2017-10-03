////
///  UIViewExtensions.swift
//

extension UIView {

    func findSubview<T>(_ test: (UIView) -> Bool) -> T? where T: UIView {
        if let view = self as? T, test(self) {
            return view
        }

        for subview in subviews {
            guard let subview: T = subview.findSubview(test) else { continue }
            return subview
        }

        return nil
    }

    func findParentView<T>(_ test: ((T) -> Bool)? = nil) -> T? where T: UIView {
        var view: UIView? = superview
        while view != nil {
            if let view = view as? T, test?(view) ?? true {
                return view
            }
            view = view?.superview
        }
        return nil
    }

}

extension UIResponder {

    func findResponder<T>() -> T? {
        var responder: UIResponder! = self
        while responder != nil {
            if let responder = responder as? T {
                return responder
            }
            responder = responder.next
        }
        return nil
    }

}
