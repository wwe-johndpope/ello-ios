////
///  NSAttributedString.swift
//

extension NSMutableAttributedString {
    override func appending(_ str: NSAttributedString) -> NSAttributedString {
        self.append(str)
        return self
    }
}

extension NSAttributedString {
    @objc
    func appending(_ str: NSAttributedString) -> NSAttributedString {
        let retval: NSMutableAttributedString = NSMutableAttributedString(attributedString: self)
        retval.append(str)
        return NSAttributedString(attributedString: retval)
    }

    convenience init(_ string: String, color: UIColor = .black, underlineStyle: NSUnderlineStyle? = nil, font: UIFont = .defaultFont(), alignment: NSTextAlignment = .left, lineBreakMode: NSLineBreakMode? = nil) {
        let paragraphStyle = NSMutableParagraphStyle()
        if lineBreakMode != .byTruncatingTail {
            paragraphStyle.lineSpacing = 6
        }
        paragraphStyle.alignment = alignment
        if let lineBreakMode = lineBreakMode {
            paragraphStyle.lineBreakMode = lineBreakMode
        }
        let underlineValue = underlineStyle?.rawValue ?? 0
        let attrs: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.foregroundColor: color,
            NSAttributedStringKey.font: font,
            NSAttributedStringKey.paragraphStyle: paragraphStyle,
            NSAttributedStringKey.underlineStyle: underlineValue,
        ]
        self.init(string: string, attributes: attrs)
    }

    convenience init(label string: String, style: StyledLabel.Style, lineBreakMode: NSLineBreakMode? = nil) {
        self.init(string, color: style.textColor, font: style.font, lineBreakMode: lineBreakMode)
    }

    convenience init(button string: String, style: StyledButton.Style, state: UIControlState = .normal, selected: Bool = false, lineBreakMode: NSLineBreakMode? = nil) {
        let stateColor: UIColor?
        if state == .disabled {
            stateColor = style.disabledTitleColor
        }
        else if state == .highlighted && selected {
            stateColor = style.unselectHighlightedTitleColor ?? style.highlightedTitleColor
        }
        else if state == .highlighted {
            stateColor = style.highlightedTitleColor
        }
        else if state == .selected {
            stateColor = style.selectedTitleColor
        }
        else {
            stateColor = style.titleColor
        }

        let color = stateColor ?? style.titleColor ?? .black
        self.init(string, color: color, underlineStyle: style.underline ? .styleSingle : .styleNone, font: style.font, lineBreakMode: lineBreakMode)
    }

    convenience init(primaryHeader: String, secondaryHeader: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let bold: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.black,
            NSAttributedStringKey.font: UIFont.defaultFont(16),
            NSAttributedStringKey.paragraphStyle: paragraphStyle,
            ]
        let plain: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.greyA,
            NSAttributedStringKey.font: UIFont.defaultFont(16),
            NSAttributedStringKey.paragraphStyle: paragraphStyle,
            ]
        let header = NSAttributedString(string: primaryHeader, attributes: bold) +
            NSAttributedString(string: " \(secondaryHeader)", attributes: plain)
        self.init(attributedString: header)
    }

    func heightForWidth(_ width: CGFloat) -> CGFloat {
        return ceil(boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil).size.height)
    }

    func widthForHeight(_ height: CGFloat) -> CGFloat {
        return ceil(boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil).size.width)
    }

    func joinWithNewlines(_ other: NSAttributedString) -> NSAttributedString {

        let retVal: NSMutableAttributedString = NSMutableAttributedString(attributedString: self)
        if other.string.characters.count > 0 {
            if self.string.characters.count > 0 {
                if !self.string.hasSuffix("\n") {
                    retVal.append(NSAttributedString("\n\n"))
                }
                else if !self.string.hasSuffix("\n\n") {
                    retVal.append(NSAttributedString("\n"))
                }
            }

            retVal.append(other)
        }

        return retVal
    }
}

func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let retval = NSMutableAttributedString(attributedString: left)
    retval.append(right)
    return NSAttributedString(attributedString: retval)
}
