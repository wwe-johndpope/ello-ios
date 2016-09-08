////
///  StyledButton.swift
//

public final class StyledButton: UIButton {
    public struct Style {
        let disabledBackgroundColor: UIColor?
        let highlightedBackgroundColor: UIColor?
        let selectedBackgroundColor: UIColor?
        let backgroundColor: UIColor?

        let disabledTitleColor: UIColor?
        let selectedTitleColor: UIColor?
        let highlightedTitleColor: UIColor?
        let titleColor: UIColor?

        let highlightedBorderColor: UIColor?
        let selectedBorderColor: UIColor?
        let borderColor: UIColor?
        let disabledBorderColor: UIColor?

        let fontSize: CGFloat?
        let cornerRadius: CGFloat?

        var font: UIFont {
            guard let size = fontSize else {
                return UIFont.defaultFont()
            }
            return UIFont.defaultFont(size)
        }

        public init(
            backgroundColor: UIColor? = nil,
            highlightedBackgroundColor: UIColor? = nil,
            selectedBackgroundColor: UIColor? = nil,
            disabledBackgroundColor: UIColor? = nil,

            titleColor: UIColor? = nil,
            highlightedTitleColor: UIColor? = nil,
            selectedTitleColor: UIColor? = nil,
            disabledTitleColor: UIColor? = nil,

            borderColor: UIColor? = nil,
            highlightedBorderColor: UIColor? = nil,
            selectedBorderColor: UIColor? = nil,
            disabledBorderColor: UIColor? = nil,

            fontSize: CGFloat? = nil,
            cornerRadius: CGFloat? = 0
        ) {
            self.disabledBackgroundColor = disabledBackgroundColor
            self.highlightedBackgroundColor = highlightedBackgroundColor
            self.selectedBackgroundColor = selectedBackgroundColor
            self.backgroundColor = backgroundColor

            self.disabledTitleColor = disabledTitleColor
            self.highlightedTitleColor = highlightedTitleColor
            self.selectedTitleColor = selectedTitleColor
            self.titleColor = titleColor

            self.disabledBorderColor = disabledBorderColor
            self.highlightedBorderColor = highlightedBorderColor
            self.selectedBorderColor = selectedBorderColor
            self.borderColor = borderColor

            self.fontSize = fontSize
            self.cornerRadius = cornerRadius
        }
    }

    public var style: Style = .Default {
        didSet { updateStyle() }
    }
    public var styleName: String = "Default" {
        didSet { style = Style.byName(styleName) }
    }

    override public var enabled: Bool {
        didSet { updateStyle() }
    }
    override public var highlighted: Bool {
        didSet { updateStyle() }
    }
    override public var selected: Bool {
        didSet { updateStyle() }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        if let cornerRadius = style.cornerRadius {
            layer.cornerRadius = cornerRadius
        }
        else {
            layer.cornerRadius = min(frame.height, frame.width) / 2
        }
    }

    private func updateStyle() {
        let layerBorder: UIColor?
        if !enabled {
            backgroundColor = style.disabledBackgroundColor ?? style.backgroundColor
            layerBorder = style.disabledBorderColor ?? style.borderColor
        }
        else if highlighted {
            backgroundColor = style.highlightedBackgroundColor ?? style.backgroundColor
            layerBorder = style.selectedBorderColor ?? style.borderColor
        }
        else if selected {
            backgroundColor = style.selectedBackgroundColor ?? style.backgroundColor
            layerBorder = style.highlightedBorderColor ?? style.borderColor
        }
        else {
            backgroundColor = style.backgroundColor
            layerBorder = style.borderColor
        }


        if let layerBorder = layerBorder {
            layer.borderColor = layerBorder.CGColor
            layer.borderWidth = 1
        }
        else {
            layer.borderWidth = 0
        }

        titleLabel?.font = style.font
        setTitleColor(style.disabledTitleColor, forState: .Disabled)
        setTitleColor(style.highlightedTitleColor, forState: .Highlighted)
        setTitleColor(style.selectedTitleColor, forState: .Selected)
        setTitleColor(style.titleColor, forState: .Normal)
    }

    required override public init(frame: CGRect) {
        super.init(frame: frame)
        sharedSetup()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedSetup()
    }

    convenience init(style: Style) {
        self.init()
        self.style = style
        updateStyle()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        if buttonType != .Custom {
            print("Warning, StyledButton instance '\(currentTitle)' should be configured as 'Custom', not \(buttonType)")
        }
    }

    private func sharedSetup() {
        titleLabel?.numberOfLines = 1
        updateStyle()
    }

    public override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        var titleRect = super.titleRectForContentRect(contentRect)
        let delta: CGFloat = 4
        titleRect.size.height += 2 * delta
        titleRect.origin.y -= delta
        return titleRect
    }
}

extension StyledButton.Style {
    public static let Default = StyledButton.Style(
        backgroundColor: .blackColor(), disabledBackgroundColor: .grey231F20(),
        titleColor: .whiteColor(), disabledTitleColor: .greyA()
        )
    public static let LightGray = StyledButton.Style(
        backgroundColor: .greyE5(), disabledBackgroundColor: .greyF1(),
        titleColor: .grey6(), highlightedTitleColor: .blackColor(), disabledTitleColor: .greyC()
        )
    public static let White = StyledButton.Style(
        backgroundColor: .whiteColor(), disabledBackgroundColor: .greyA(),
        titleColor: .blackColor(), highlightedTitleColor: .grey6(), disabledTitleColor: .greyC()
        )
    public static let SquareBlack = StyledButton.Style(
        backgroundColor: .whiteColor(), disabledBackgroundColor: .greyA(),
        titleColor: .blackColor(), highlightedTitleColor: .grey6(), disabledTitleColor: .greyC(),
        borderColor: .blackColor(), highlightedBorderColor: .greyE5()
        )
    public static let RoundedBlack = StyledButton.Style(
        backgroundColor: .clearColor(), disabledBackgroundColor: .greyF2(),
        titleColor: .blackColor(), highlightedTitleColor: .grey6(), disabledTitleColor: .greyC(),
        borderColor: .blackColor(), disabledBorderColor: .greyF2(),
        cornerRadius: nil
        )
    public static let RoundedGray = StyledButton.Style(
        backgroundColor: .clearColor(), disabledBackgroundColor: .greyF2(),
        titleColor: .greyA(), highlightedTitleColor: .blackColor(), disabledTitleColor: .greyC(),
        borderColor: .greyA(), disabledBorderColor: .greyF2(),
        cornerRadius: 5
        )
    public static let InviteFriend = StyledButton.Style(
        backgroundColor: .greyA(),
        titleColor: .whiteColor(),
        cornerRadius: nil
        )
    public static let Invited = StyledButton.Style(
        backgroundColor: .greyE5(),
        titleColor: .grey6(),
        cornerRadius: nil
        )
    public static let BlockUserModal = StyledButton.Style(
        backgroundColor: .whiteColor(), selectedBackgroundColor: .blackColor(), disabledBackgroundColor: .greyA(),
        titleColor: .blackColor(), highlightedTitleColor: .grey6(), selectedTitleColor: .whiteColor(), disabledTitleColor: .greyC()
        )
    public static let GrayText = StyledButton.Style(
        titleColor: .greyA()
        )
    public static let Green = StyledButton.Style(
        backgroundColor: .greenD1(), disabledBackgroundColor: .grey6(),
        titleColor: .whiteColor(), highlightedTitleColor: .greyA(), disabledTitleColor: .whiteColor(),
        cornerRadius: 5
        )

    public static func byName(name: String) -> StyledButton.Style {
        switch name {
        case "LightGray": return .LightGray
        case "White": return .White
        case "SquareBlack": return .SquareBlack
        case "RoundedBlack": return .RoundedBlack
        case "RoundedGray": return .RoundedGray
        case "InviteFriend": return .InviteFriend
        case "Invited": return .Invited
        case "BlockUserModal": return .BlockUserModal
        case "GrayText": return .GrayText
        case "Green": return .Green
        default: return .Default
        }
    }
}
