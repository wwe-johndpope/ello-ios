////
///  StyledButton.swift
//

public final class StyledButton: UIButton {
    public struct Style {
        var disabledBackgroundColor: UIColor?
        var highlightedBackgroundColor: UIColor?
        var selectedBackgroundColor: UIColor?
        var backgroundColor: UIColor?

        var disabledTitleColor: UIColor?
        var selectedTitleColor: UIColor?
        var highlightedTitleColor: UIColor?
        var titleColor: UIColor?

        var highlightedBorderColor: UIColor?
        var selectedBorderColor: UIColor?
        var borderColor: UIColor?
        var disabledBorderColor: UIColor?

        var fontSize: CGFloat?
        var cornerRadius: CGFloat?

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
        if !enabled {
            backgroundColor = style.disabledBackgroundColor ?? style.backgroundColor
            if let borderColor = style.disabledBorderColor ?? style.borderColor {
                layer.borderColor = borderColor.CGColor
            }
        }
        else if highlighted {
            backgroundColor = style.highlightedBackgroundColor ?? style.backgroundColor
            if let borderColor = style.selectedBorderColor ?? style.borderColor {
                layer.borderColor = borderColor.CGColor
            }
        }
        else if selected {
            backgroundColor = style.selectedBackgroundColor ?? style.backgroundColor
            if let borderColor = style.highlightedBorderColor ?? style.borderColor {
                layer.borderColor = borderColor.CGColor
            }
        }
        else {
            backgroundColor = style.backgroundColor
            if let borderColor = style.borderColor {
                layer.borderColor = borderColor.CGColor
            }
        }

        if style.borderColor != nil {
            layer.borderWidth = 1
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
}
