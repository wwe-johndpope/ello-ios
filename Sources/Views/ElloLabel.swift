////
///  ElloLabel.swift
//

import Foundation
import UIKit
import ElloUIFonts

public class ElloLabel: UILabel {
    override public var text: String? { didSet { updateLabelText() } }
    override public var textColor: UIColor? { didSet { updateLabelText() } }
    override public var textAlignment: NSTextAlignment { didSet { updateLabelText() } }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateLabelText()
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

    private func updateLabelText() {
        guard let text = text, textColor = textColor else { return }

        let attrs = attributes(textColor, alignment: textAlignment)
        attributedText = NSAttributedString(string: text, attributes: attrs)
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
