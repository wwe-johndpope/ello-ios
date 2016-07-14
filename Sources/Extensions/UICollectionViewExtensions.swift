////
///  UICollectionViewExtensions.swift
//

import Foundation

extension UICollectionView {
    public func lastIndexPathForSection(section: Int) -> NSIndexPath? {
        if self.numberOfItemsInSection(section) > 0 {
            return NSIndexPath(forItem: self.numberOfItemsInSection(section) - 1, inSection: section)
        }
        return nil
    }
}
