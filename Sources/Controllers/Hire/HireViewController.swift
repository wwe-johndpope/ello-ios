////
///  HireViewController.swift
//

import FutureKit


public class HireViewController: BaseElloViewController {
    public enum UserEmailType {
        case Hire
        case Collaborate
    }

    let user: User
    let contactType: UserEmailType
    var mockScreen: HireScreenProtocol?
    var screen: HireScreenProtocol { return mockScreen ?? (self.view as! HireScreenProtocol) }
    var keyboardWillShowObserver: NotificationObserver?
    var keyboardWillHideObserver: NotificationObserver?

    required public init(user: User, type: UserEmailType) {
        self.user = user
        self.contactType = type
        super.init(nibName: nil, bundle: nil)

        switch contactType {
        case .Hire:
            title = NSString.localizedStringWithFormat(InterfaceString.Hire.HireTitleTemplate, user.atName) as String
        case .Collaborate:
            title = NSString.localizedStringWithFormat(InterfaceString.Hire.CollaborateTitleTemplate, user.atName) as String
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadView() {
        elloNavigationItem.title = title

        let item = UIBarButtonItem.backChevronWithTarget(self, action: #selector(backTapped(_:)))
        elloNavigationItem.leftBarButtonItems = [item]
        elloNavigationItem.fixNavBarItemPadding()

        let screen = HireScreen()
        screen.navigationItem = elloNavigationItem
        screen.delegate = self
        screen.recipient = user.displayName
        self.view = screen
    }

    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
        UIApplication.sharedApplication().statusBarStyle = .LightContent

        elloTabBarController?.tabBarHidden = false

        keyboardWillShowObserver = NotificationObserver(notification: Keyboard.Notifications.KeyboardWillShow, block: self.keyboardWillShow)
        keyboardWillHideObserver = NotificationObserver(notification: Keyboard.Notifications.KeyboardWillHide, block: self.keyboardWillHide)
        screen.toggleKeyboard(visible: Keyboard.shared.active)
    }

    override public func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        keyboardWillShowObserver?.removeObserver()
        keyboardWillShowObserver = nil
        keyboardWillHideObserver?.removeObserver()
        keyboardWillHideObserver = nil
    }

    public func keyboardWillShow(keyboard: Keyboard) {
        screen.toggleKeyboard(visible: true)
    }

    public func keyboardWillHide(keyboard: Keyboard) {
        screen.toggleKeyboard(visible: false)
    }

}

extension HireViewController: HireDelegate {
    func submit(body body: String) {
        guard !body.isEmpty else { return }

        self.screen.showSuccess()
        let hireSuccess = after(2) {
            self.navigationController?.popViewControllerAnimated(true)
            delay(DefaultAppleAnimationDuration) {
                self.screen.hideSuccess()
            }
        }
        // this ensures a minimum 3 second display of the success screen
        delay(3) {
            hireSuccess()
        }

        let endpoint: Future<Void>
        switch contactType {
        case .Hire:
            endpoint = HireService().hire(user: user, body: body)
        case .Collaborate:
            endpoint = HireService().collaborate(user: user, body: body)
        }

        endpoint
            .onSuccess { _ in
                Tracker.sharedTracker.hiredUser(self.user)
                hireSuccess()
            }
            .onFail { error in
                self.screen.hideSuccess()
                let alertController = AlertViewController(error: InterfaceString.GenericError)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
    }
}
