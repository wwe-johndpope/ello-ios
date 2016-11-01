////
///  UIViewExtensions.swift
//

extension UIView {

    public func findParentView<T where T: UIView>(test: ((T) -> Bool)? = nil) -> T? {
        var view: UIView? = superview
        while view != nil {
            if let view = view as? T where test?(view) ?? true {
                return view
            }
            view = view?.superview
        }
        return nil
    }
}
