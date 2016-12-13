////
///  AutoCompleteCell.swift
//

public class AutoCompleteCell: UITableViewCell {
    static let reuseIdentifier = "AutoCompleteCell"

    @IBOutlet weak public var name: UILabel!
    weak public var avatar: AvatarButton!
    @IBOutlet weak public var line: UIView!

    public struct Size {
        static let height: CGFloat = 49
    }
}

public extension AutoCompleteCell {
    class func nib() -> UINib {
        return UINib(nibName: "AutoCompleteCell", bundle: .None)
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        avatar.setDefaultImage()
    }
}
