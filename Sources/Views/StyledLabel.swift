////
///  StyledLabel.swift
//

public class StyledLabel: UILabel {
    public enum FontFamily {
        case Small
        case Normal
        case Large
        case LargeBold
        case Bold

        var font: UIFont {
            switch self {
            case .Small: return UIFont.defaultFont(12)
            case .Normal: return UIFont.defaultFont()
            case .Large: return UIFont.defaultFont(18)
            case .LargeBold: return UIFont.defaultBoldFont(18)
            case .Bold: return UIFont.defaultBoldFont()
            }
        }
    }

    public struct Style {
        let backgroundColor: UIColor
        let textColor: UIColor
        let fontFamily: FontFamily

        var font: UIFont {
            return fontFamily.font
        }

        public init(
            textColor: UIColor,
            backgroundColor: UIColor = .clearColor(),

            fontFamily: FontFamily = .Normal
        ) {
            self.textColor = textColor
            self.backgroundColor = backgroundColor

            self.fontFamily = fontFamily
        }
    }

    struct Size {
        static let extraBottomMargin: CGFloat = 10
    }

    public override var text: String? {
        didSet { updateStyle() }
    }
    public var style: Style = .Default {
        didSet { updateStyle() }
    }
    public var styleName: String = "Default" {
        didSet { style = Style.byName(styleName) }
    }

    private func updateStyle() {
        backgroundColor = style.backgroundColor

        font = style.font
        textColor = style.textColor

        if let text = text {
            attributedText = NSAttributedString(label: text, style: style)
        }
    }

    required override public init(frame: CGRect) {
        super.init(frame: frame)
        updateStyle()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        updateStyle()
    }

    convenience init(style: Style) {
        self.init()
        self.style = style
        updateStyle()
    }
}

// MARK: UIView Overrides
extension StyledLabel {

    private func heightForWidth(width: CGFloat) -> CGFloat {
        return (attributedText?.boundingRectWithSize(CGSize(width: width, height: CGFloat.max),
            options: [.UsesLineFragmentOrigin, .UsesFontLeading],
            context: nil).size.height).map(ceil) ?? 0
    }

    public override func sizeThatFits(size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = heightForWidth(size.width) + Size.extraBottomMargin
        return size
    }
}

extension StyledLabel.Style {
    public static let Default = StyledLabel.Style(
        textColor: .blackColor()
        )
    public static let SmallWhite = StyledLabel.Style(
        textColor: .whiteColor(),
        fontFamily: .Small
        )
    public static let White = StyledLabel.Style(
        textColor: .whiteColor()
        )
    public static let BoldWhite = StyledLabel.Style(
        textColor: .whiteColor(),
        fontFamily: .Bold
        )
    public static let LargeWhite = StyledLabel.Style(
        textColor: .whiteColor(),
        fontFamily: .LargeBold
        )
    public static let Black = StyledLabel.Style(
        textColor: .blackColor()
        )
    public static let Large = StyledLabel.Style(
        textColor: .blackColor(),
        fontFamily: .LargeBold
        )
    public static let Gray = StyledLabel.Style(
        textColor: .greyA()
        )
    public static let LightGray = StyledLabel.Style(
        textColor: UIColor(hex: 0x9a9a9a)
        )
    public static let LargePlaceholder = StyledLabel.Style(
        textColor: .greyC(),
        fontFamily: .Large
        )
    public static let Error = StyledLabel.Style(
        textColor: .redColor()
        )

    public static func byName(name: String) -> StyledLabel.Style {
        switch name {
        case "SmallWhite": return .SmallWhite
        case "White": return .White
        case "BoldWhite": return .BoldWhite
        case "LargeWhite": return .LargeWhite

        case "Black": return .Black
        case "Large": return .Large

        case "Gray": return .Gray
        case "LightGray": return .LightGray

        case "Error": return .Error

        default: return .Default
        }
    }
}
