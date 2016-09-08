////
///  SearchTextField.swift
//

public class SearchTextField: UITextField {
    override public var placeholder: String? {
        didSet {
            if let placeholder = placeholder {
                attributedPlaceholder = NSAttributedString(
                    string: placeholder,
                    attributes: [
                        NSForegroundColorAttributeName: UIColor.greyA()
                    ])
            }
        }
    }
    private var line = UIView()

    override required public init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }

    private func sharedInit() {
        clearButtonMode = .WhileEditing
        font = .defaultFont(18)
        textColor = .blackColor()
        autocapitalizationType = .None
        autocorrectionType = .No
        spellCheckingType = .No
        enablesReturnKeyAutomatically = true
        returnKeyType = .Search
        keyboardAppearance = .Dark
        keyboardType = .Default
        leftViewMode = .Always
        leftView = UIImageView(image: InterfaceImage.Search.normalImage)

        addSubview(line)
        line.backgroundColor = .greyA()
        line.snp_makeConstraints { make in
            make.leading.trailing.equalTo(self)
            make.bottom.equalTo(self).offset(-10)
            make.height.equalTo(1)
        }
    }

    override public func textRectForBounds(bounds: CGRect) -> CGRect {
        return rectForBounds(bounds)
    }

    override public func editingRectForBounds(bounds: CGRect) -> CGRect {
        return rectForBounds(bounds)
    }

    private func rectForBounds(bounds: CGRect) -> CGRect {
        let rect = super.editingRectForBounds(bounds)
        return rect.shrinkRight(10)
    }
}
