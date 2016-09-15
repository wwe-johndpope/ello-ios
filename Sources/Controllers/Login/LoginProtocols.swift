////
///  LoginProtocols.swift
//

protocol LoginDelegate: class {
    func backAction()
    func forgotPasswordAction()
    func onePasswordAction(sender: UIView)
    func validate(username username: String, password: String)
    func submit(username username: String, password: String)
}

protocol LoginScreenProtocol: class {
    var username: String { get set }
    var usernameValid: Bool? { get set }
    var password: String { get set }
    var passwordValid: Bool? { get set }
    var onePasswordAvailable: Bool { get set }
    func loadingHUD(visible visible: Bool)
    func showError(text: String)
    func hideError()
    func resignFirstResponder() -> Bool
}
