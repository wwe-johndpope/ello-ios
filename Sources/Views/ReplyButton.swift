////
///  ReplyButton.swift
//

class ReplyButton: RoundedElloButton {
    override func sharedSetup() {
        super.sharedSetup()
        setTitle(InterfaceString.Notifications.Reply, forState: .Normal)
        setImage(InterfaceImage.Reply.selectedImage, forState: .Normal)
        contentEdgeInsets.left = 10
        contentEdgeInsets.right = 10
        imageEdgeInsets.right = 5
    }
}
