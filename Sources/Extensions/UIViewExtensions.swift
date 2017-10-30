////
///  UIViewExtensions.swift
//

extension UIView {

    func findAllSubviews<T>(_ test: ((T) -> Bool)? = nil) -> [T] where T: UIView {
        var views: [T] = []
        if let view = self as? T, test?(view) ?? true {
            views.append(view)
        }

        for subview in subviews {
            let subviews: [T] = subview.findAllSubviews(test)
            views += subviews
        }

        return views
    }

    func findSubview<T>(_ test: ((T) -> Bool)? = nil) -> T? where T: UIView {
        if let view = self as? T, test?(view) ?? true {
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
