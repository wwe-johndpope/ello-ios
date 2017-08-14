////
///  PushNotificationController.swift
//

import SwiftyUserDefaults
import UserNotifications


private let NeedsPermissionKey = "PushNotificationNeedsPermission"
private let DeniedPermissionKey = "PushNotificationDeniedPermission"

struct PushNotificationNotifications {
    static let interactedWithPushNotification = TypedNotification<PushPayload>(name: "com.Ello.PushNotification.Interaction")
    static let receivedPushNotification = TypedNotification<PushPayload>(name: "com.Ello.PushNotification.Received")
}

struct PushActions {
    static let ownPostCategory = "co.ello.OWN_POST_CATEGORY"
    static let otherPostCategory = "co.ello.POST_CATEGORY"
    static let commentCategory = "co.ello.COMMENT_CATEGORY"
    static let userCategory = "co.ello.USER_CATEGORY"

    static let followUser = "co.ello.FOLLOW_USER_ACTION"
    static let lovePost = "co.ello.LOVE_POST_ACTION"
    static let postComment = "co.ello.POST_COMMENT_ACTION"
    static let commentReply = "co.ello.COMMENT_REPLY_ACTION"
}

class PushNotificationController: NSObject {
    static let sharedController = PushNotificationController(defaults: GroupDefaults, keychain: ElloKeychain())

    fileprivate let defaults: UserDefaults
    fileprivate var keychain: KeychainType

    var needsPermission: Bool {
        get { return defaults[NeedsPermissionKey].bool ?? true }
        set { defaults[NeedsPermissionKey] = newValue }
    }

    var permissionDenied: Bool {
        get { return defaults[DeniedPermissionKey].bool ?? false }
        set { defaults[DeniedPermissionKey] = newValue }
    }

    init(defaults: UserDefaults, keychain: KeychainType) {
        self.defaults = defaults
        self.keychain = keychain
    }
}

extension PushNotificationController: UNUserNotificationCenterDelegate {

    // foreground - notification incoming while using the app
    @objc @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        receivedNotification(UIApplication.shared, action: nil, userInfo: notification.request.content.userInfo)
        completionHandler(UNNotificationPresentationOptions.sound)
    }

    // background - user interacted with notification outside of the app
    @objc @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        receivedNotification(UIApplication.shared, action: response.actionIdentifier, userInfo: response.notification.request.content.userInfo)
        completionHandler()
    }
}

extension PushNotificationController {
    func requestPushAccessIfNeeded(_ vc: UIViewController) {
        guard AuthToken().isPasswordBased else { return }
        guard !permissionDenied else { return }

        guard !needsPermission else {
            vc.present(alertViewController(), animated: true, completion: nil)
            return
        }

        registerForRemoteNotifications()
        return
    }

    func registerForRemoteNotifications() {
        self.needsPermission = false
        registerStoredToken()
        let app = UIApplication.shared

        if #available(iOS 10.0, *){
            let replyAction = UNTextInputNotificationAction(identifier: PushActions.commentReply, title: "Reply", options: [.authenticationRequired], textInputButtonTitle: "Send", textInputPlaceholder: "")
            let commentAction = UNTextInputNotificationAction(identifier: PushActions.postComment, title: "Comment", options: [.authenticationRequired], textInputButtonTitle: "Send", textInputPlaceholder: "")
            let loveAction = UNNotificationAction(identifier: PushActions.lovePost, title: "Love", options: [.authenticationRequired])
            let followAction = UNNotificationAction(identifier: PushActions.followUser, title: "Follow", options: [.authenticationRequired])

            let ownPostCategory = UNNotificationCategory(identifier: PushActions.ownPostCategory, actions: [], intentIdentifiers: [], options: [])
            let otherPostCategory = UNNotificationCategory(identifier: PushActions.otherPostCategory, actions: [loveAction, commentAction], intentIdentifiers: [], options: [])
            let commentCategory = UNNotificationCategory(identifier: PushActions.commentCategory, actions: [replyAction], intentIdentifiers: [], options: [])
            let userCategory = UNNotificationCategory(identifier: PushActions.userCategory, actions: [followAction], intentIdentifiers: [], options: [])

            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.setNotificationCategories([ownPostCategory, otherPostCategory, commentCategory, userCategory])
            center.requestAuthorization(options: [.badge, .sound, .alert]) {
                (granted, _) in
                if granted {
                    app.registerForRemoteNotifications()
                }
            }
        }

        else { //If user is not on iOS 10 use the old methods we've been using
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: [])
            app.registerUserNotificationSettings(settings)
            app.registerForRemoteNotifications()
        }
    }

    func updateToken(_ token: Data) {
        keychain.pushToken = token
        ProfileService().updateUserDeviceToken(token).ignoreErrors()
    }

    func registerStoredToken() {
        if let token = keychain.pushToken {
            ProfileService().updateUserDeviceToken(token).ignoreErrors()
        }
    }

    func deregisterStoredToken() {
        if let token = keychain.pushToken {
            ProfileService().removeUserDeviceToken(token).ignoreErrors()
        }
    }

    func receivedNotification(_ application: UIApplication, action: String?, userInfo: [AnyHashable: Any]) {
        updateBadgeCount(userInfo)
        if !hasAlert(userInfo) { return }

        let payload = PushPayload(info: userInfo as! [String: Any])
        if application.applicationState == .active {
            NotificationBanner.displayAlert(payload: payload)
        }
        else {
            switch action ?? "" {
            case PushActions.lovePost:
                print("here!")
                break
            default:
                postNotification(PushNotificationNotifications.interactedWithPushNotification, value: payload)
            }
        }
    }

    func updateBadgeCount(_ userInfo: [AnyHashable: Any]) {
        if let aps = userInfo["aps"] as? [AnyHashable: Any],
            let badges = aps["badge"] as? Int
        {
            updateBadgeNumber(badges)
        }
    }

    func updateBadgeNumber(_ badges: Int) {
        UIApplication.shared.applicationIconBadgeNumber = badges
    }

    func hasAlert(_ userInfo: [AnyHashable: Any]) -> Bool {
        if let aps = userInfo["aps"] as? [AnyHashable: Any], aps["alert"] is [NSObject: Any]
        {
            return true
        }
        else {
            return false
        }
    }
}

private extension PushNotificationController {
    func alertViewController() -> AlertViewController {
        let alert = AlertViewController(message: InterfaceString.PushNotifications.PermissionPrompt)
        alert.dismissable = false

        let allowAction = AlertAction(title: InterfaceString.PushNotifications.PermissionYes, style: .dark) { _ in
            self.registerForRemoteNotifications()
        }
        alert.addAction(allowAction)

        let disallowAction = AlertAction(title: InterfaceString.PushNotifications.PermissionNo, style: .light) { _ in
            self.needsPermission = false
            self.permissionDenied = true
        }
        alert.addAction(disallowAction)
        return alert
    }
}
