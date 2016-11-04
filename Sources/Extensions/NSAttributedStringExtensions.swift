////
///  NSAttributedString.swift
//

import Foundation

extension NSAttributedString {
    func append(str: NSAttributedString) -> NSAttributedString {
        let retval: NSMutableAttributedString = NSMutableAttributedString(attributedString: self)
        retval.appendAttributedString(str)
        return NSAttributedString(attributedString: retval)
    }

    public convenience init(_ string: String, color: UIColor = .blackColor(), underlineStyle: NSUnderlineStyle? = nil, font: UIFont = .defaultFont(), alignment: NSTextAlignment = .Left) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = alignment
        let underlineValue = underlineStyle?.rawValue ?? 0
        let attrs: [String: AnyObject] = [
            NSForegroundColorAttributeName: color,
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: paragraphStyle,
            NSUnderlineStyleAttributeName: underlineValue
        ]
        self.init(string: string, attributes: attrs)
    }

    public convenience init(primaryHeader: String, secondaryHeader: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let bold: [String: AnyObject] = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont.defaultFont(16),
            NSParagraphStyleAttributeName: paragraphStyle,
            ]
        let plain: [String: AnyObject] = [
            NSForegroundColorAttributeName: UIColor.greyA(),
            NSFontAttributeName: UIFont.defaultFont(16),
            NSParagraphStyleAttributeName: paragraphStyle,
            ]
        let header = NSAttributedString(string: primaryHeader, attributes: bold) +
            NSAttributedString(string: " \(secondaryHeader)", attributes: plain)
        self.init(attributedString: header)
    }

    func widthForHeight(height: CGFloat) -> CGFloat {
        return ceil(boundingRectWithSize(CGSize(width: CGFloat.max, height: height),
            options: [.UsesLineFragmentOrigin, .UsesFontLeading],
            context: nil).size.width)
    }

    func joinWithNewlines(other: NSAttributedString) -> NSAttributedString {
        let retVal = NSMutableAttributedString(attributedString: self)
        if other.string.characters.count > 0 {
            if self.string.characters.count > 0 {
                if !self.string.endsWith("\n") {
                    retVal.appendAttributedString(NSAttributedString("\n\n"))
                }
                else if !self.string.endsWith("\n\n") {
                    retVal.appendAttributedString(NSAttributedString("\n"))
                }
            }

            retVal.appendAttributedString(other)
        }

        return retVal
    }
}

func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    return left.append(right)
}
