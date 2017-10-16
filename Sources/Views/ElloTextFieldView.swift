////
///  ElloTextFieldView.swift
//

private let ElloTextFieldViewHeight: CGFloat = 89.0

class ElloTextFieldView: UIView {
    @IBOutlet weak var label: StyledLabel!
    @IBOutlet weak var textField: ElloTextField!
    @IBOutlet weak var errorLabel: StyledLabel!
    @IBOutlet weak var messageLabel: StyledLabel!

    @IBOutlet weak var errorLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var messageLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var errorLabelSeparationSpacing: NSLayoutConstraint!

    var textFieldDidChange: ((String) -> Void)?
    var firstResponderDidChange: ((Bool) -> Void)? {
        get { return textField.firstResponderDidChange }
        set { textField.firstResponderDidChange = newValue }
    }

    var height: CGFloat {
        var height = ElloTextFieldViewHeight
        if hasError {
            height += errorHeight
            if hasMessage {
                height += 20
            }
            else {
                height += 8
            }
        }
        if hasMessage {
            height += messageHeight + 8
        }
        return height
    }

    var hasError: Bool { return !(errorLabel.text?.isEmpty ?? true) }
    var hasMessage: Bool { return !(messageLabel.text?.isEmpty ?? true) }
    var errorHeight: CGFloat {
        if hasError {
            return errorLabel.sizeThatFits(CGSize(width: errorLabel.frame.width, height: 0)).height
        }
        else {
            return 0
        }
    }
    var messageHeight: CGFloat {
        if hasMessage {
            return messageLabel.sizeThatFits(CGSize(width: messageLabel.frame.width, height: 0)).height
        }
        else {
            return 0
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }

    private func sharedInit() {
        let view: UIView = loadFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)

        textField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
    }

    override func updateConstraints() {
        updateErrorConstraints()
        super.updateConstraints()
    }

    func setState(_ state: ValidationState) {
        textField.validationState = state
    }

    @objc
    func valueChanged() {
        setNeedsUpdateConstraints()
        if let textFieldDidChange = textFieldDidChange, let text = textField.text {
            textFieldDidChange(text)
        }
    }

    func setErrorMessage(_ message: String) {
        errorLabel.text = message
        setNeedsUpdateConstraints()
        self.invalidateIntrinsicContentSize()
    }

    func setMessage(_ message: String) {
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        setNeedsUpdateConstraints()
        self.invalidateIntrinsicContentSize()
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.label.layoutIfNeeded()
        self.textField.layoutIfNeeded()
        self.messageLabel.layoutIfNeeded()
        self.errorLabel.layoutIfNeeded()
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: height)
    }

    private func updateErrorConstraints() {
        errorLabelSeparationSpacing.isActive = errorHeight > 0 && messageHeight > 0
        errorLabelHeight.constant = errorHeight
        messageLabelHeight.constant = messageHeight
    }

    func clearState() {
        textField.validationState = .none
        setErrorMessage("")
        setMessage("")
    }

    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }

}


extension ElloTextFieldView {
    private class func styleCommonField(_ textField: UITextField) {
        textField.text = ""
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.enablesReturnKeyAutomatically = true
        textField.keyboardAppearance = .dark
    }

    class func styleAsUsername(_ usernameView: ElloTextFieldView) {
        usernameView.label.text = InterfaceString.Join.Username
        styleAsUsernameField(usernameView.textField)
    }
    class func styleAsUsernameField(_ textField: UITextField) {
        styleCommonField(textField)
        textField.returnKeyType = .next
        textField.keyboardType = .asciiCapable
    }

    class func styleAsEmail(_ emailView: ElloTextFieldView) {
        emailView.label.text = InterfaceString.Join.Email
        styleAsEmailField(emailView.textField)
    }
    class func styleAsEmailField(_ textField: UITextField) {
        styleCommonField(textField)
        textField.returnKeyType = .next
        textField.keyboardType = .emailAddress
    }

    class func styleAsPassword(_ passwordView: ElloTextFieldView) {
        passwordView.label.text = InterfaceString.Join.Password
        styleAsPasswordField(passwordView.textField)
    }
    class func styleAsPasswordField(_ textField: UITextField) {
        styleCommonField(textField)
        textField.returnKeyType = .go
        textField.keyboardType = .default
        textField.isSecureTextEntry = true
    }

}
