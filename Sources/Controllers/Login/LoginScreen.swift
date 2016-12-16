////
///  LoginScreen.swift
//

import SnapKit


public class LoginScreen: CredentialsScreen {
    struct Size {
        static let fieldsTopMargin: CGFloat = 55
        static let fieldsInnerMargin: CGFloat = 30
        static let buttonHeight: CGFloat = 50
        static let buttonInset: CGFloat = 10
        static let forgotPasswordFontSize: CGFloat = 11
    }

    weak var delegate: LoginDelegate?
    var username: String {
        get { return usernameField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) ?? "" }
        set { usernameField.text = newValue }
    }
    var usernameValid: Bool? = nil {
        didSet {
            if let usernameValid = usernameValid {
                usernameField.validationState = usernameValid ? .OKSmall : .Error
                styleContinueButton()
            }
            else {
                usernameField.validationState = .None
            }
        }
    }
    var password: String {
        get { return passwordField.text ?? "" }
        set { passwordField.text = newValue }
    }
    var passwordValid: Bool? = nil {
        didSet {
            if let passwordValid = passwordValid {
                passwordField.validationState = passwordValid ? .OKSmall : .Error
                styleContinueButton()
            }
            else {
                passwordField.validationState = .None
            }
        }
    }
    var onePasswordAvailable = false {
        didSet { passwordField.hasOnePassword = onePasswordAvailable }
    }

    let usernameField = ClearTextField()
    private let activateUsernameButton = UIButton()
    let passwordField = ClearTextField()
    private let activatePasswordButton = UIButton()
    private let errorLabel = StyledLabel(style: .SmallWhite)

    private let forgotPasswordButton = UIButton()
    private let continueButton = StyledButton(style: .RoundedGray)
    private let continueBackground = UIView()

    override func setText() {
        titleLabel.text = InterfaceString.Startup.Login
        usernameField.placeholder = InterfaceString.Login.UsernamePlaceholder
        passwordField.placeholder = InterfaceString.Login.PasswordPlaceholder
        continueButton.setTitle(InterfaceString.Login.Continue, forState: .Normal)
        forgotPasswordButton.setTitle(InterfaceString.Login.ForgotPassword, forState: .Normal)
    }

    override func bindActions() {
        super.bindActions()
        continueButton.addTarget(self, action: #selector(submitAction), forControlEvents: .TouchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordAction), forControlEvents: .TouchUpInside)
        passwordField.onePasswordButton.addTarget(self, action: #selector(onePasswordAction(_:)), forControlEvents: .TouchUpInside)
        usernameField.addTarget(self, action: #selector(textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        usernameField.delegate = self
        activateUsernameButton.addTarget(self, action: #selector(activateUsername), forControlEvents: .TouchUpInside)
        passwordField.addTarget(self, action: #selector(textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        passwordField.delegate = self
        activatePasswordButton.addTarget(self, action: #selector(activatePassword), forControlEvents: .TouchUpInside)
    }

    override func style() {
        super.style()

        ElloTextFieldView.styleAsEmailField(usernameField)

        ElloTextFieldView.styleAsPasswordField(passwordField)
        passwordField.hasOnePassword = onePasswordAvailable

        continueBackground.backgroundColor = .whiteColor()

        forgotPasswordButton.titleLabel?.font = UIFont.defaultFont(Size.forgotPasswordFontSize)
        forgotPasswordButton.setTitleColor(.greyA(), forState: .Normal)
    }

    private func styleContinueButton() {
        let allValid: Bool
        if let usernameValid = usernameValid,
            passwordValid = passwordValid
        {
            allValid = usernameValid && passwordValid
        }
        else {
            allValid = false
        }

        if allValid {
            continueButton.style = .Green
        }
        else {
            continueButton.style = .RoundedGray
        }
    }

    override func arrange() {
        super.arrange()

        scrollView.addSubview(activateUsernameButton)
        scrollView.addSubview(usernameField)
        scrollView.addSubview(activatePasswordButton)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(forgotPasswordButton)
        scrollView.addSubview(errorLabel)

        addSubview(continueBackground)
        continueBackground.addSubview(continueButton)

        scrollView.snp_makeConstraints { make in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(blackBar.snp_bottom)
            make.bottom.equalTo(continueBackground.snp_top)
        }

        let scrollViewAnchor = UIView()
        scrollView.addSubview(scrollViewAnchor)
        scrollViewAnchor.snp_makeConstraints { make in
            make.leading.trailing.top.equalTo(scrollView)
            scrollViewWidthConstraint = make.width.equalTo(frame.size.width).priorityRequired().constraint
        }

        usernameField.snp_makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottom).offset(Size.fieldsTopMargin)
            make.leading.trailing.equalTo(scrollView).inset(CredentialsScreen.Size.inset)
        }
        activateUsernameButton.snp_makeConstraints { make in
            make.leading.trailing.equalTo(scrollView)
            make.centerY.equalTo(usernameField)
            make.height.equalTo(usernameField).offset(Size.fieldsInnerMargin)
        }

        passwordField.snp_makeConstraints { make in
            make.top.equalTo(usernameField.snp_bottom).offset(Size.fieldsInnerMargin)
            make.leading.trailing.equalTo(scrollView).inset(CredentialsScreen.Size.inset)
        }
        activatePasswordButton.snp_makeConstraints { make in
            make.leading.trailing.equalTo(scrollView)
            make.centerY.equalTo(passwordField)
            make.height.equalTo(passwordField).offset(Size.fieldsInnerMargin)
        }

        forgotPasswordButton.snp_makeConstraints { make in
            make.top.equalTo(passwordField.snp_bottom).offset(Size.fieldsInnerMargin)
            make.trailing.equalTo(scrollView).inset(Size.buttonInset)
        }

        continueButton.snp_makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(Size.buttonInset)
            make.bottom.equalTo(keyboardAnchor.snp_top).offset(-Size.buttonInset)
            make.height.equalTo(Size.buttonHeight)
        }

        continueBackground.snp_makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self)
            make.top.equalTo(continueButton).offset(-Size.buttonInset)
        }

        errorLabel.snp_makeConstraints { make in
            make.firstBaseline.equalTo(forgotPasswordButton)
            make.leading.trailing.equalTo(scrollView).inset(Size.inset)
            make.bottom.lessThanOrEqualTo(scrollView).inset(Size.inset)
        }
    }

    override public func resignFirstResponder() -> Bool {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return super.resignFirstResponder()
    }
}

// MARK: Actions
extension LoginScreen {
    override public func backAction() {
        delegate?.backAction()
    }

    public func forgotPasswordAction() {
        delegate?.forgotPasswordAction()
    }

    public func submitAction() {
        delegate?.submit(username: username, password: password)
    }

    public func onePasswordAction(sender: UIView) {
        delegate?.onePasswordAction(sender)
    }

    public func activateUsername() {
        usernameField.becomeFirstResponder()
    }

    public func activatePassword() {
        passwordField.becomeFirstResponder()
    }
}

// MARK: UITextFieldDelegate
extension LoginScreen: UITextFieldDelegate {
    public func textFieldDidChange(textField: UITextField) {
        delegate?.validate(username: username, password: password)
    }

    public func textFieldDidEndEditing(textField: UITextField) {
        textField.setNeedsLayout()
        textField.layoutIfNeeded()
    }

    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case usernameField:
            Tracker.sharedTracker.enteredEmail()
            passwordField.becomeFirstResponder()
            return true
        case passwordField:
            Tracker.sharedTracker.enteredPassword()
            delegate?.submit(username: username, password: password)
            return false
        default:
            return true
        }
    }
}

// MARK: LoginScreenProtocol
extension LoginScreen: LoginScreenProtocol {
    func loadingHUD(visible visible: Bool) {
        if visible {
            ElloHUD.showLoadingHudInView(self)
        }
        else {
            ElloHUD.hideLoadingHudInView(self)
        }
        usernameField.enabled = !visible
        passwordField.enabled = !visible
        userInteractionEnabled = !visible
    }

    func showError(text: String) {
        errorLabel.text = text
        usernameValid = false
        passwordValid = false

        animate {
            self.errorLabel.alpha = 1.0
            self.layoutIfNeeded()
        }
    }

    func hideError() {
        animate {
            self.errorLabel.alpha = 0.0
            self.layoutIfNeeded()
        }
    }
}
