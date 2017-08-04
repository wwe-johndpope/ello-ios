////
///  StreamRegionableCell.swift
//

class StreamRegionableCell: CollectionViewCell {
    var leftBorder = CALayer()

    override func style() {
        super.style()
        leftBorder.backgroundColor = UIColor.black.cgColor
    }

    func showBorder() {
        layer.addSublayer(leftBorder)
    }

    func hideBorder() {
        leftBorder.removeFromSuperlayer()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        leftBorder.frame = CGRect(x: 15, y: 0, width: 1, height: self.bounds.height)
    }
}
