////
///  StreamToggleCell.swift
//

public class StreamToggleCell: UICollectionViewCell {
    static let reuseIdentifier = "StreamToggleCell"

    let closedMessage = InterfaceString.NSFW.Show
    let openedMessage = InterfaceString.NSFW.Hide

    weak var label: ElloToggleLabel!
}
