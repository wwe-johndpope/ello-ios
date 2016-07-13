////
///  StreamRegionableCell.swift
//

import Foundation

public class StreamRegionableCell: UICollectionViewCell {
    public var leftBorder = CALayer()

    override public func awakeFromNib() {
        super.awakeFromNib()
        leftBorder.backgroundColor = UIColor.blackColor().CGColor
    }

    public func showBorder() {
        self.layer.addSublayer(leftBorder)
    }

    public func hideBorder() {
        leftBorder.removeFromSuperlayer()
    }

    override public func layoutSubviews() {
        leftBorder.frame = CGRect(x: 15, y: 0, width: 1, height: self.bounds.height)
        super.layoutSubviews()
    }
}
