////
///  StreamSeeMoreCommentsCell.swift
//

import Foundation


public class StreamSeeMoreCommentsCell: UICollectionViewCell {
    static let reuseIdentifier = "StreamSeeMoreCommentsCell"

    @IBOutlet weak public var buttonContainer: UIView!
    @IBOutlet weak public var seeMoreButton: UIButton!

    override public func awakeFromNib() {
        super.awakeFromNib()
        style()
    }

    private func style() {
        buttonContainer.backgroundColor = .greyA()
        seeMoreButton.setTitleColor(UIColor.greyA(), forState: UIControlState.Normal)
        seeMoreButton.backgroundColor = .whiteColor()
        seeMoreButton.titleLabel?.font = .defaultFont()
    }

}
