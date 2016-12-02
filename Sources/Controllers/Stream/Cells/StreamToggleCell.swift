////
///  StreamToggleCell.swift
//

public class StreamToggleCell: UICollectionViewCell {
    static let reuseIdentifier = "StreamToggleCell"

    weak var label: ElloLabel!

    override public func awakeFromNib() {
        super.awakeFromNib()
        label.textColor = .greyA()
    }
}
