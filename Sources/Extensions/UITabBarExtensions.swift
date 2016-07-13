////
///  UITabBarExtensions.swift
//

extension UITabBar {

    var itemViews: [UIView] {
        return subviews.filter { $0 is UIControl }
    }

    func itemPositionsIn(view: UIView) -> [CGRect] {
        return itemViews.map { self.convertRect($0.frame, toView: view) }
    }

}
