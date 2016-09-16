////
///  ElloUnderlinedTextButton.swift
//

public class ElloUnderlinedTextButton: UIButton {

    required override public init(frame: CGRect) {
        super.init(frame: frame)
        sharedSetup()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedSetup()
    }

    private func sharedSetup() {
        self.backgroundColor = UIColor.clearColor()
        let lineBreakMode = self.titleLabel?.lineBreakMode ?? .ByWordWrapping
        if lineBreakMode != .ByWordWrapping {
            self.titleLabel?.numberOfLines = 1
        }
        self.setTitleColor(UIColor.greyA(), forState: UIControlState.Normal)
        self.titleLabel?.font = UIFont.defaultFont()

        if let title = self.titleLabel?.text {
            let attributedString = NSAttributedString(string: title, attributes: [
                NSFontAttributeName: UIFont.defaultFont(),
                NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
                ])
            self.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        }
    }
}
