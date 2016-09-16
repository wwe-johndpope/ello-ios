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

extension UICollectionViewCell {
    public var indexPath: NSIndexPath? {
        var superview: UIView? = self.superview
        while superview != nil {
            if superview is UICollectionView { break }
            superview = superview?.superview
        }

        guard let collectionView = superview as? UICollectionView else { return nil }

        for path in collectionView.indexPathsForVisibleItems() {
            guard let
                cell = collectionView.cellForItemAtIndexPath(path)
            where cell == self
            else { continue }

            return path
        }
        return nil
    }
}
