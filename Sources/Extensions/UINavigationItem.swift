////
///  UINavigationItem.swift
//

import Foundation

extension UINavigationItem {

    func fixNavBarItemPadding() {
        if let rightBarButtonItems = self.rightBarButtonItems {
            let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
            negativeSpacer.width = -22

            self.rightBarButtonItems = [negativeSpacer] + rightBarButtonItems
        }

        if let leftBarButtonItems = self.leftBarButtonItems {
            let negativeSpacer = UIBarButtonItem.spacer(width: -17)
            self.leftBarButtonItems = [negativeSpacer] + leftBarButtonItems
        }
    }

    public func areRightButtonsTheSame(newItems: [UIBarButtonItem]) -> Bool {
        guard let rightItems = self.rightBarButtonItems else { return false }
        guard newItems.count == rightItems.count else { return false }
        return newItems.map({ $0.action }) == rightItems.map({ $0.action })
    }

}
