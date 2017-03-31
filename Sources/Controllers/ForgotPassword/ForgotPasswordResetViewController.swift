////
///  ForgotPasswordResetViewController.swift
//

class ForgotPasswordResetViewController: BaseElloViewController {
    var mockScreen: ForgotPasswordResetScreenProtocol?
    var screen: ForgotPasswordResetScreenProtocol { return mockScreen ?? (self.view as! ForgotPasswordResetScreenProtocol) }

    let authToken: String

    init(authToken: String) {
        self.authToken = authToken
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let screen = ForgotPasswordResetScreen()
        screen.delegate = self
        self.view = screen
    }
}

extension ForgotPasswordResetViewController: ForgotPasswordResetDelegate {
    func submit(password: String) {
        Tracker.shared.tappedReset()

        _ = screen.resignFirstResponder()

        if Validator.isValidPassword(password) {
            screen.hidePasswordError()
            screen.loadingHUD(visible: true)
            Tracker.shared.resetPasswordValid()

            UserService().resetPassword(password: password, authToken: authToken)
                .onSuccess {
                    self.screen.loadingHUD(visible: false)
                }
                .onFail { error in
                    self.screen.loadingHUD(visible: false)
                    self.screen.showFailureMessage()
                }
        }
        else {
            if let msg = Validator.invalidSignUpPasswordReason(password) {
                screen.showPasswordError(msg)
            }
            else {
                screen.hidePasswordError()
            }
        }
    }

    func backAction() {
        _ = navigationController?.popViewController(animated: true)
    }

    func validate(password: String) {
        if Validator.invalidSignUpPasswordReason(password) == nil {
            screen.passwordValid = true
        }
        else {
            screen.passwordValid = nil
        }
    }
}
