////
///  StreamInviteFriendsCell.swift
//

import Foundation

public class StreamInviteFriendsCell: UICollectionViewCell {
    static let reuseIdentifier = "StreamInviteFriendsCell"

    @IBOutlet weak public var nameLabel: UILabel!
    @IBOutlet weak public var inviteButton: StyledButton!

    public var inviteDelegate: InviteDelegate?
    public var inviteCache: InviteCache?
    var bottomBorder = CALayer()

    public var person: LocalPerson? {
        didSet {
            nameLabel.text = person!.name
            styleInviteButton(inviteCache?.has(person!.identifier))
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = UIFont.defaultFont(18)
        nameLabel.textColor = UIColor.greyA()
        nameLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        // bottom border
        bottomBorder.backgroundColor = UIColor.greyF1().CGColor
        self.layer.addSublayer(bottomBorder)
    }

    override public func layoutSubviews() {
        bottomBorder.frame = CGRect(x: 0, y: self.bounds.height - 1, width: self.bounds.width, height: 1)
        super.layoutSubviews()
    }

    @IBAction func invite() {
        if let person = person {
            inviteDelegate?.sendInvite(person) {
                self.inviteCache?.saveInvite(person.identifier)
                self.styleInviteButton(self.inviteCache?.has(person.identifier))
            }
        }
    }

    public func styleInviteButton(invited: Bool? = false) {
        if invited == true {
            inviteButton.style = .Invited
            inviteButton.setTitle(InterfaceString.Friends.Resend, forState: UIControlState.Normal)
        }
        else {
            inviteButton.style = .InviteFriend
            inviteButton.setTitle(InterfaceString.Friends.Invite, forState: UIControlState.Normal)
        }
    }
}
