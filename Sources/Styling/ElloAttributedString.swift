////
///  ElloAttributedString.swift
//

let ParagraphAlignmentAttributeName = NSAttributedStringKey("ParagraphAlignmentAttributeName")

struct ElloAttributedString {
    private struct HtmlTagTuple {
        let tag: String
        let attributes: String?

        init(_ tag: String, attributes: String? = nil) {
            self.tag = tag
            self.attributes = attributes
        }
    }

    static func oldAttrs(_ oldAddrs: [NSAttributedStringKey: Any]) -> [String: Any] {
        return oldAddrs.convert { key, value in
            return (key.rawValue, value)
        }
    }

    static func attrs(_ allAddlAttrs: [NSAttributedStringKey: Any]...) -> [NSAttributedStringKey: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6

        var attrs: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.paragraphStyle: paragraphStyle,
            NSAttributedStringKey.font: UIFont.defaultFont(),
            NSAttributedStringKey.foregroundColor: UIColor.black,
        ]
        for addlAttrs in allAddlAttrs {
            attrs += addlAttrs
        }
        return attrs
    }

    static func linkAttrs() -> [NSAttributedStringKey: Any] {
        return attrs([
            NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue,
        ])
    }

    static func split(_ text: NSAttributedString, split: String = "\n") -> [NSAttributedString] {
        var strings = [NSAttributedString]()
        var current = NSMutableAttributedString()
        var hasLetters = false
        var startNewString = false
        let nsCount = (text.string as NSString).length
        for i in 0..<nsCount {
            let letter = NSMutableAttributedString(attributedString: text)
            if i < nsCount - 1 {
                letter.deleteCharacters(in: NSRange(location: i + 1, length: nsCount - i - 1))
            }
            if i > 0 {
                letter.deleteCharacters(in: NSRange(location: 0, length: i))
            }

            if letter.string == "\n" {
                current.append(letter)
                startNewString = true
            }
            else {
                if !startNewString {
                    hasLetters = true
                }
                else if hasLetters {
                    strings.append(current)
                    current = NSMutableAttributedString()
                }
                current.append(letter)
                startNewString = false
            }
        }
        if !current.string.isEmpty {
            strings.append(current)
        }
        return strings
    }

    static func style(_ text: String, _ addlAttrs: [NSAttributedStringKey: Any] = [:]) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: attrs(addlAttrs))
    }

    static func parse(_ input: String) -> NSAttributedString? {
        if let tag = Tag(input: input) {
            return tag.makeEditable(attrs())
        }
        return nil
    }

    static func render(_ input: NSAttributedString) -> String {
        var output = ""
        input.enumerateAttributes(in: NSRange(location: 0, length: input.length), options: .longestEffectiveRangeNotRequired) { attrs, nsrange, stopPtr in
            // (tagName, attributes?)
            var tags = [HtmlTagTuple]()
            if let underlineStyle = attrs[NSAttributedStringKey.underlineStyle] as? Int, underlineStyle == NSUnderlineStyle.styleSingle.rawValue {
                tags.append(HtmlTagTuple("u"))
            }

            if let font = attrs[NSAttributedStringKey.font] as? UIFont {
                if font.fontName == UIFont.editorBoldFont().fontName {
                    tags.append(HtmlTagTuple("strong"))
                }
                else if font.fontName == UIFont.editorBoldItalicFont().fontName {
                    tags.append(HtmlTagTuple("strong"))
                    tags.append(HtmlTagTuple("em"))
                }
                else if font.fontName == UIFont.editorItalicFont().fontName {
                    tags.append(HtmlTagTuple("em"))
                }
            }

            if let link = attrs[NSAttributedStringKey.link] as? URL {
                tags.append(HtmlTagTuple("a", attributes: "href=\"\(link.absoluteString.entitiesEncoded())\""))
            }

            for htmlTag in tags {
                output += "<\(htmlTag.tag)"
                if let attrs = htmlTag.attributes {
                    output += " "
                    output += attrs
                }
                output += ">"
            }

            let string = input.string
            if let range = string.rangeFromNSRange(nsrange) {
                output += String(string[range]).entitiesEncoded()
            }

            for htmlTag in tags.reversed() {
                output += "</\(htmlTag.tag)>"
            }
        }
        return output
    }

    static func featuredIn(categories: [Category], attrs: [NSAttributedStringKey: Any] = [:]) -> NSAttributedString {
        let defaultAttributes = featuredInAttrs(attrs)
        var featuredIn = NSAttributedString(string: InterfaceString.Profile.FeaturedIn, attributes: featuredInAttrs(defaultAttributes, attrs))

        let count = categories.count
        for (index, category) in categories.enumerated() {
            let prefix: NSAttributedString
            if index == count - 1 && count > 1 {
                prefix = NSAttributedString(string: " & ", attributes: defaultAttributes)
            }
            else if index > 0 {
                prefix = NSAttributedString(string: ", ", attributes: defaultAttributes)
            }
            else {
                prefix = NSAttributedString(string: " ", attributes: defaultAttributes)
            }
            featuredIn = featuredIn.appending(prefix)
                .appending(style(category: category, attrs: attrs))
        }

        return featuredIn
    }

    private static func featuredInAttrs(_ allAddlAttrs: [NSAttributedStringKey: Any]...) -> [NSAttributedStringKey: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .center

        var attrs: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.paragraphStyle: paragraphStyle,
            NSAttributedStringKey.font: UIFont.defaultFont(18),
            NSAttributedStringKey.foregroundColor: UIColor.white,
        ]
        for addlAttrs in allAddlAttrs {
            attrs += addlAttrs
        }

        if let alignmentInt = attrs[ParagraphAlignmentAttributeName] as? Int,
            let alignment = NSTextAlignment(rawValue: alignmentInt)
        {
            paragraphStyle.alignment = alignment
        }

        return attrs
    }

    private static func style(category: Category, attrs: [NSAttributedStringKey: Any]) -> NSAttributedString {
        return NSAttributedString(string: category.name, attributes: featuredInAttrs([
            ElloAttributedText.Link: "category",
            ElloAttributedText.Object: category,
            NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue,
        ], attrs))
    }
}
