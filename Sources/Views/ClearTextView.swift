////
///  ClearTextView.swift
//

public class ClearTextView: UITextView {
    struct Size {
        static let minTextViewHeight: CGFloat = 38
        static let placeholderOffset: CGFloat = 3
    }
    public var lineColor: UIColor? = .grey6() {
        didSet {
            if !isFirstResponder() {
                line.backgroundColor = lineColor
            }
        }
    }
    public var selectedLineColor: UIColor? = .whiteColor() {
        didSet {
            if isFirstResponder() {
                line.backgroundColor = selectedLineColor
            }
        }
    }
    public var placeholder: String? {
        get { return placeholderLabel.text }
        set { placeholderLabel.text = newValue }
    }
    public var placeholderColor: UIColor? {
        didSet {
            if let placeholderColor = placeholderColor {
                placeholderLabel.textColor = placeholderColor
            }
            else {
                placeholderLabel.textColor = (textColor ?? UIColor.blackColor()).colorWithAlphaComponent(0.6)
            }
        }
    }
    override public var text: String? {
        didSet {
            textDidChange()
        }
    }
    override public var textColor: UIColor? {
        didSet { updateTextStyle() }
    }
    override public var font: UIFont? {
        didSet { updateTextStyle() }
    }
    private var line = UIView()
    private let placeholderLabel = ElloSizeableLabel()
    private let rightView = UIImageView()
    var validationState = ValidationState.None {
        didSet {
            rightView.image = validationState.imageRepresentation
            rightView.sizeToFit()
            setNeedsLayout()
        }
    }

    required override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        sharedSetup()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedSetup()
    }

    func sharedSetup() {
        backgroundColor = .clearColor()
        font = .defaultFont(18)
        textColor = .whiteColor()
        textContainerInset = UIEdgeInsets(top: 2.5, left: -5, bottom: 0, right: 30)
        updateTextStyle()

        addSubview(placeholderLabel)
        placeholderLabel.font = .defaultFont(18)
        placeholderLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
        placeholderLabel.snp_makeConstraints { make in
            make.top.equalTo(self).offset(Size.placeholderOffset)
            make.leading.trailing.equalTo(self)
        }

        addSubview(line)
        line.backgroundColor = lineColor

        addSubview(rightView)
    }

    public func textDidChange() {
        placeholderLabel.hidden = text?.isEmpty == false
        invalidateIntrinsicContentSize()
    }

    private func updateTextStyle() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 12
        var attributes: [String: AnyObject] = [
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        if let font = font {
            attributes[NSFontAttributeName] = font
        }
        if let textColor = textColor {
            attributes[NSForegroundColorAttributeName] = textColor
        }
        typingAttributes = attributes
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        rightView.frame.origin = CGPoint(x: frame.size.width - rightView.frame.size.width - 10, y: 0)
        line.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
    }

    override public func intrinsicContentSize() -> CGSize {
        let fixedWidth = max(self.frame.size.width, 20)
        let newSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        return CGSize(width: fixedWidth, height: max(newSize.height + 2.5, Size.minTextViewHeight))
    }

    override public func becomeFirstResponder() -> Bool {
        line.backgroundColor = selectedLineColor
        return super.becomeFirstResponder()
    }

    override public func resignFirstResponder() -> Bool {
        line.backgroundColor = lineColor
        return super.resignFirstResponder()
    }

    override public func caretRectForPosition(position: UITextPosition) -> CGRect {
        var rect = super.caretRectForPosition(position)
        if let font = font {
            rect.size.height = font.pointSize - font.descender
        }
        return rect
    }
}
