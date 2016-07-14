////
///  ElloLabel.swift
//

import Foundation
import UIKit
import ElloUIFonts

public class ElloLabel: UILabel {
    override public var text: String? {
        didSet {
            if let text = text {
                setLabelText(text, color: textColor, alignment: textAlignment)
            }
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let text = text {
            setLabelText(text, color: textColor)
        }
    }

    public init() {
        super.init(frame: .zero)
    }

    func attributes(color: UIColor, alignment: NSTextAlignment) -> [String : AnyObject] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = alignment

        return [
            NSFontAttributeName: UIFont.defaultFont(),
            NSForegroundColorAttributeName: color,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
    }
}

// MARK: UIView Overrides
extension ElloLabel {
    public override func sizeThatFits(size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = heightForWidth(size.width) + 10
        return size
    }
}

public extension ElloLabel {
    func setLabelText(title: String, color: UIColor = UIColor.whiteColor(), alignment: NSTextAlignment = .Left) {
        textColor = color
        textAlignment = alignment
        let attrs = attributes(color, alignment: alignment)
        attributedText = NSAttributedString(string: title, attributes: attrs)
    }

    func height() -> CGFloat {
        return heightForWidth(self.frame.size.width)
    }

    func heightForWidth(width: CGFloat) -> CGFloat {
        return (attributedText?.boundingRectWithSize(CGSize(width: width, height: CGFloat.max),
            options: [.UsesLineFragmentOrigin, .UsesFontLeading],
            context: nil).size.height).map(ceil) ?? 0
    }

}

public class ElloToggleLabel: ElloLabel {
    public override func setLabelText(title: String, color: UIColor = UIColor.greyA(), alignment: NSTextAlignment = .Left) {
        super.setLabelText(title, color: color, alignment: alignment)
    }
}

public class ElloErrorLabel: ElloLabel {
    public override func setLabelText(title: String, color: UIColor = UIColor.redColor(), alignment: NSTextAlignment = .Left) {
        super.setLabelText(title, color: color, alignment: alignment)
    }
}

public class ElloSizeableLabel: ElloLabel {
    override public func attributes(color: UIColor, alignment: NSTextAlignment) -> [String: AnyObject] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = alignment

        return [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: color,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
    }
}
