////
///  ProfileViewButtons.swift
//

public class ProfileButton: RoundedElloButton {
    override public func sharedSetup() {
        super.sharedSetup()

        setTitleColor(UIColor.blackColor(), forState: .Normal)
        setTitleColor(UIColor.grey6(), forState: .Highlighted)
        setTitleColor(UIColor.greyC(), forState: .Disabled)
    }

    override func updateOutline() {
        super.updateOutline()
        backgroundColor = highlighted ? UIColor.grey4D() : UIColor.whiteColor()
    }
}

public class ElloMentionButton: RoundedElloButton {
    override public func sharedSetup() {
        super.sharedSetup()
        setTitle(InterfaceString.Profile.Mention, forState: .Normal)
    }
}

public class ElloEditProfileButton: RoundedElloButton {
    override public func sharedSetup() {
        super.sharedSetup()
        setTitle(InterfaceString.Profile.EditProfile, forState: .Normal)
    }
}
