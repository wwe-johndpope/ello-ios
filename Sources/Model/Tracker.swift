////
///  Tracker.swift
//

import Analytics
import Keys
import Crashlytics

func logPresentingAlert(name: String) {
    Crashlytics.sharedInstance().setObjectValue(name, forKey: CrashlyticsKey.AlertPresenter.rawValue)
}


public enum ContentType: String {
    case Post = "Post"
    case Comment = "Comment"
    case User = "User"
}

public protocol AnalyticsAgent {
    func identify(userId: String!, traits: [NSObject: AnyObject]!)
    func track(event: String!)
    func track(event: String!, properties: [NSObject: AnyObject]!)
    func screen(screenTitle: String!)
    func screen(screenTitle: String!, properties: [NSObject: AnyObject]!)
    func reset()
}

public struct NullAgent: AnalyticsAgent {
    public func identify(userId: String!, traits: [NSObject: AnyObject]!) { }
    public func track(event: String!) { }
    public func track(event: String!, properties: [NSObject: AnyObject]!) { }
    public func screen(screenTitle: String!) { }
    public func screen(screenTitle: String!, properties: [NSObject: AnyObject]!) { }
    public func reset() { }
}

extension SEGAnalytics: AnalyticsAgent { }

public class Tracker {
    public static var responseHeaders: NSString = ""
    public static var responseJSON: NSString = ""

    public var overrideAgent: AnalyticsAgent?
    public static let sharedTracker = Tracker()
    var settingChangedNotification: NotificationObserver?
    private var shouldTrackUser = true
    private var currentUser: User?
    private var agent: AnalyticsAgent {
        return overrideAgent ?? (shouldTrackUser ? SEGAnalytics.sharedAnalytics() : NullAgent())
    }

    public init() {
        let configuration = SEGAnalyticsConfiguration(writeKey: ElloKeys().segmentKey())
         SEGAnalytics.setupWithConfiguration(configuration)

        settingChangedNotification = NotificationObserver(notification: SettingChangedNotification) { user in
            self.shouldTrackUser = user.profile?.allowsAnalytics ?? true
            Crashlytics.sharedInstance().setUserIdentifier(self.shouldTrackUser ? user.id : "")
        }
    }
}

// MARK: Session Info
public extension Tracker {

    func identify(user: User) {
        currentUser = user
        shouldTrackUser = user.profile?.allowsAnalytics ?? true
        Crashlytics.sharedInstance().setUserIdentifier(shouldTrackUser ? user.id : "")
        if let analyticsId = user.profile?.gaUniqueId {
            agent.identify(analyticsId, traits: [ "created_at": user.profile?.createdAt.toServerDateString() ?? "no-creation-date" ])
        }
    }

    func sessionStarted() {
        agent.track("Session Began")
    }

    func sessionEnded() {
        agent.track("Session Ended")
    }

    static func trackRequest(headers headers: String, statusCode: Int, responseJSON: String) {
        Tracker.responseHeaders = headers
        Crashlytics.sharedInstance().setObjectValue(headers, forKey: CrashlyticsKey.ResponseHeaders.rawValue)
        Crashlytics.sharedInstance().setObjectValue("\(statusCode)", forKey: CrashlyticsKey.ResponseStatusCode.rawValue)
        Tracker.responseJSON = responseJSON
        Crashlytics.sharedInstance().setObjectValue(Tracker.responseJSON, forKey: CrashlyticsKey.ResponseJSON.rawValue)
    }
}

// MARK: Signup and Login
public extension Tracker {

    func tappedJoinFromStartup() {
        agent.track("tapped join from startup")
    }

    func tappedLoginFromStartup() {
        agent.track("tapped sign in from startup")
    }

    func tappedJoinFromLogin() {
        agent.track("tapped join from sign-in")
    }

    func tappedLoginFromJoin() {
        agent.track("tapped sign in from join")
    }

    func enteredEmail() {
        agent.track("entered email and pressed 'next'")
    }

    func enteredUsername() {
        agent.track("entered username and pressed 'next'")
    }

    func enteredPassword() {
        agent.track("entered password and pressed 'next'")
    }

    func tappedJoin() {
        agent.track("tapped join")
    }

    func tappedAbout() {
        agent.track("tapped about")
    }

    func tappedTsAndCs() {
        agent.track("tapped terms and conditions")
    }

    func joinValid() {
        agent.track("join valid")
    }

    func joinInvalid() {
        agent.track("join invalid")
    }

    func joinSuccessful() {
        agent.track("join successful")
    }

    func joinFailed() {
        agent.track("join failed")
    }

    func tappedLogin() {
        agent.track("tapped sign in")
    }

    func loginValid() {
        agent.track("sign-in valid")
    }

    func loginInvalid() {
        agent.track("sign-in invalid")
    }

    func loginSuccessful() {
        agent.track("sign-in successful")
    }

    func loginFailed() {
        agent.track("sign-in failed")
    }

    func tappedForgotPassword() {
        agent.track("forgot password tapped")
    }

    func tappedLogout() {
        agent.track("logout tapped")
    }

}

// MARK: iRate
public extension Tracker {
    func ratePromptShown() {
        agent.track("rate prompt shown")
    }

    func ratePromptUserDeclinedToRateApp() {
        agent.track("rate prompt user declined to rate app")
    }

    func ratePromptRemindMeLater() {
        agent.track("rate prompt remind me later")
    }

    func ratePromptUserAttemptedToRateApp() {
        agent.track("rate prompt user attempted to rate app")
    }

    func ratePromptOpenedAppStore() {
        agent.track("rate prompt opened app store")
    }

    func ratePromptCouldNotConnectToAppStore() {
        agent.track("rate prompt could not connect to app store")
    }
}

// MARK: Hire Me
public extension Tracker {
    func tappedHire(user: User) {
        agent.track("open hire dialog profile", properties: ["id": user.id])
    }
    func hiredUser(user: User) {
        agent.track("send hire dialog profile", properties: ["id": user.id])
    }
}

// MARK: Share Extension
public extension Tracker {
    func shareSuccessful() {
        agent.track("successfully shared from the share extension")
    }

    func shareFailed() {
        agent.track("failed to share from the share extension")
    }
}

// MARK: Onboarding
public extension Tracker {
    func completedCategories() {
        agent.track("completed categories in onboarding")
    }

    func skippedCategories() {
        agent.track("skipped categories in onboarding")
    }

    func skippedContactImport() {
        agent.track("skipped contact import")
    }

    func completedContactImport() {
        agent.track("completed contact import")
    }

    func skippedNameBio() {
        agent.track("skipped name_bio")
    }

    func addedNameBio() {
        agent.track("added name_bio")
    }
}

public extension UIViewController {
    func trackerName() -> String { return readableClassName() }
    func trackerProps() -> [String: AnyObject]? { return nil }

    func trackerData() -> (String, [String: AnyObject]?) {
        return (trackerName(), trackerProps())
    }
}

// MARK: View Appearance
public extension Tracker {
    func screenAppeared(viewController: UIViewController) {
        let (name, props) = viewController.trackerData()
        screenAppeared(name, properties: props)
    }

    func discoverCategory(category: String) {
        agent.track("DiscoverViewController category filter", properties: ["category": category])
    }

    func screenAppeared(name: String, properties: [String: AnyObject]? = nil) {
        agent.screen(name, properties: properties)
    }

    func streamAppeared(kind: String) {
        agent.screen("Stream", properties: ["kind": kind])
    }

    func webViewAppeared(url: String) {
        agent.screen("Web View", properties: ["url": url])
    }

    func profileLoaded(handle: String) {
        agent.track("Profile Loaded", properties: ["handle": handle])
    }

    func postLoaded(id: String) {
        agent.track("Post Loaded", properties: ["id": id])
    }

    func viewedImage(asset: Asset, post: Post) {
        agent.track("Viewed Image", properties: ["asset_id": asset.id, "post_id": post.id])
    }

    func postBarVisibilityChanged(visible: Bool) {
        let visibility = visible ? "shown" : "hidden"
        agent.track("Post bar \(visibility)")
    }

    func commentBarVisibilityChanged(visible: Bool) {
        let visibility = visible ? "shown" : "hidden"
        agent.track("Comment bar \(visibility)")
    }

    func drawerClosed() {
        agent.track("Drawer closed")
    }

    func viewsButtonTapped(post post: Post) {
        agent.track("Views button tapped", properties: ["post_id": post.id])
    }

    func deepLinkVisited(path: String) {
        agent.track("Deep Link Visited", properties: ["path": path])
    }

    func buyButtonLinkVisited(path: String) {
        agent.track("Buy Button Link Visited", properties: ["link": path])
    }

}

// MARK: Content Actions
public extension Tracker {
    private func regionDetails(regions: [Regionable]?) -> [String: AnyObject] {
        guard let regions = regions else {
            return [:]
        }

        var imageCount = 0
        var textLength = 0
        for region in regions {
            if region.kind == RegionKind.Image.rawValue {
                imageCount += 1
            }
            else if let region = region as? TextRegion {
                textLength += region.content.characters.count
            }
        }

        return [
            "total_regions": regions.count,
            "image_regions": imageCount,
            "text_length": textLength
        ]
    }

    func postCreated(post: Post) {
        let type: ContentType = .Post
        let properties = regionDetails(post.content)
        agent.track("\(type.rawValue) created", properties: properties)
    }

    func postEdited(post: Post) {
        let type: ContentType = .Post
        let properties = regionDetails(post.content)
        agent.track("\(type.rawValue) edited", properties: properties)
    }

    func commentCreated(comment: ElloComment) {
        let type: ContentType = .Comment
        let properties = regionDetails(comment.content)
        agent.track("\(type.rawValue) created", properties: properties)
    }

    func commentEdited(comment: ElloComment) {
        let type: ContentType = .Comment
        let properties = regionDetails(comment.content)
        agent.track("\(type.rawValue) edited", properties: properties)
    }

    func contentCreated(type: ContentType) {
        agent.track("\(type.rawValue) created")
    }

    func contentEdited(type: ContentType) {
        agent.track("\(type.rawValue) edited")
    }

    func contentCreationCanceled(type: ContentType) {
        agent.track("\(type.rawValue) creation canceled")
    }

    func contentEditingCanceled(type: ContentType) {
        agent.track("\(type.rawValue) editing canceled")
    }

    func contentCreationFailed(type: ContentType, message: String) {
        agent.track("\(type.rawValue) creation failed", properties: ["message": message])
    }

    func contentFlagged(type: ContentType, flag: ContentFlagger.AlertOption, contentId: String) {
        agent.track("\(type.rawValue) flagged", properties: ["content_id": contentId, "flag": flag.rawValue])
    }

    func contentFlaggingCanceled(type: ContentType, contentId: String) {
        agent.track("\(type.rawValue) flagging canceled", properties: ["content_id": contentId])
    }

    func contentFlaggingFailed(type: ContentType, message: String, contentId: String) {
        agent.track("\(type.rawValue) flagging failed", properties: ["content_id": contentId, "message": message])
    }

    func userShared(user: User) {
        agent.track("User shared", properties: ["user_id": user.id])
    }

    func postReposted(post: Post) {
        agent.track("Post reposted", properties: ["post_id": post.id])
    }

    func postShared(post: Post) {
        agent.track("Post shared", properties: ["post_id": post.id])
    }

    func postLoved(post: Post) {
        agent.track("Post loved", properties: ["post_id": post.id])
    }

    func postUnloved(post: Post) {
        agent.track("Post unloved", properties: ["post_id": post.id])
    }
}

// MARK: User Actions
public extension Tracker {
    func userBlocked(userId: String) {
        agent.track("User blocked", properties: ["blocked_user_id": userId])
    }

    func userMuted(userId: String) {
        agent.track("User muted", properties: ["muted_user_id": userId])
    }

    func userUnblocked(userId: String) {
        agent.track("User UN-blocked", properties: ["blocked_user_id": userId])
    }

    func userUnmuted(userId: String) {
        agent.track("User UN-muted", properties: ["muted_user_id": userId])
    }

    func userBlockCanceled(userId: String) {
        agent.track("User block canceled", properties: ["blocked_user_id": userId])
    }

    func relationshipStatusUpdated(relationshipPriority: RelationshipPriority, userId: String) {
        agent.track("Relationship Priority changed", properties: ["new_value": relationshipPriority.rawValue, "user_id": userId])
    }

    func relationshipStatusUpdateFailed(relationshipPriority: RelationshipPriority, userId: String) {
        agent.track("Relationship Priority failed", properties: ["new_value": relationshipPriority.rawValue, "user_id": userId])
    }

    func relationshipButtonTapped(relationshipPriority: RelationshipPriority, userId: String) {
        agent.track("Relationship button tapped", properties: ["button": relationshipPriority.buttonName, "user_id": userId])
    }

    func friendInvited() {
        agent.track("User invited")
    }

    func userDeletedAccount() {
        agent.track("User deleted account")
    }
}

// MARK: Image Actions
public extension Tracker {
    func imageAddedFromCamera() {
        agent.track("Image added from camera")
    }

    func imageAddedFromLibrary() {
        agent.track("Image added from library")
    }

    func addImageCanceled() {
        agent.track("Image addition canceled")
    }
}

// MARK: Import Friend Actions
public extension Tracker {
    func inviteFriendsTapped() {
        agent.track("Invite Friends tapped")
    }

    func importContactsInitiated() {
        agent.track("Import Contacts initiated")
    }

    func importContactsDenied() {
        agent.track("Import Contacts denied")
    }

    func addressBookAccessed() {
        agent.track("Address book accessed")
    }
}

// MARK:  Preferences
public extension Tracker {
    func pushNotificationPreferenceChanged(granted: Bool) {
        let accessLevel = granted ? "granted" : "denied"
        agent.track("Push notification access \(accessLevel)")
    }

    func contactAccessPreferenceChanged(granted: Bool) {
        let accessLevel = granted ? "granted" : "denied"
        agent.track("Address book access \(accessLevel)")
    }
}

// MARK: Errors
public extension Tracker {
    func encounteredNetworkError(path: String, error: NSError, statusCode: Int?) {
        agent.track("Encountered network error", properties: ["path": path, "message": error.description, "statusCode": statusCode ?? 0])
    }

    func createdAtCrash(identifier: String, json: String?) {
        let jsonText: NSString = json ?? Tracker.responseJSON
        agent.track("\(identifier) Created At Crash", properties: ["responseHeaders": Tracker.responseHeaders, "responseJSON": jsonText, "currentUserId": currentUser?.id ?? "no id"])
    }
}

// MARK: Search
public extension Tracker {
    func searchFor(type: String) {
        agent.track("Search for \(type)")
    }
}
