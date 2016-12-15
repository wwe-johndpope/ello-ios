////
///  DrawerCell.swift
//

public class DrawerCell: UITableViewCell {
    static let reuseIdentifier = "DrawerCell"
    @IBOutlet weak public var label: UILabel!
    @IBOutlet weak public var line: UIView!

    override public func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .grey6()
        line.backgroundColor = .grey5()
        label.font = UIFont.defaultFont()
        label.textColor = .whiteColor()
    }
}

public extension DrawerCell {
    class func nib() -> UINib {
        return UINib(nibName: "DrawerCell", bundle: .None)
    }
}
