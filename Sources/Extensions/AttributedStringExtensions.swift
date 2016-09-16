////
///  DictionaryExtensions.swift
//

import Foundation

extension NSAttributedString {
    func append(str: NSAttributedString) -> NSAttributedString {
        let retval: NSMutableAttributedString = NSMutableAttributedString(attributedString: self)
        retval.appendAttributedString(str)
        return NSAttributedString(attributedString: retval)
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
}

func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    return left.append(right)
}
