////
///  NewContentService.swift
//

import SwiftyUserDefaults


struct NewContentNotifications {
    static let newAnnouncements = TypedNotification<()>(name: "NewAnnouncementsNotification")
    static let newNotifications = TypedNotification<()>(name: "NewNotificationsNotification")
    static let newFollowingContent = TypedNotification<()>(name: "NewFollowingContentNotification")
    static let reloadFollowingContent = TypedNotification<()>(name: "ReloadFollowingContentNotification")
    static let reloadNotifications = TypedNotification<()>(name: "ReloadNotificationsNotification")
}

class NewContentService {
    var timer: Timer?
    init(){}
}

extension NewContentService {

    func startPolling() {
        checkForNewNotifications()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self, selector: #selector(NewContentService.checkForNewContent), userInfo: nil, repeats: false)
    }

    func restartPolling() {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self, selector: #selector(NewContentService.checkForNewContent), userInfo: nil, repeats: false)
    }

    func stopPolling() {
        timer?.invalidate()
    }

    @objc
    func checkForNewContent() {
        stopPolling()
        let (restart, done) = afterN(restartPolling)
        checkForNewNotifications(restart())
        checkForNewFollowingContent(restart())
        done()
    }

    func updateCreatedAt(_ jsonables: [JSONAble], streamKind: StreamKind) {
        guard let storedKey = streamKind.lastViewedCreatedAtKey else { return }

        let old = Date(timeIntervalSince1970: 0)
        let new = newestDate(jsonables)
        let storedDate = GroupDefaults[storedKey].date ?? old
        let mostRecent = new > storedDate ? new : storedDate
        GroupDefaults[storedKey] = mostRecent
    }
}

private extension NewContentService {

    func newestDate(_ jsonables: [JSONAble]) -> Date {
        let old = Date(timeIntervalSince1970: 0)
        return jsonables.reduce(old) {
            (date, jsonable) -> Date in
            if let post = jsonable as? Post {
                return post.createdAt as Date > date ? post.createdAt as Date : date
            }
            else if let notification = jsonable as? Notification {
                return notification.createdAt as Date > date ? notification.createdAt as Date : date
            }
            else if let activity = jsonable as? Activity {
                return activity.createdAt as Date > date ? activity.createdAt as Date : date
            }
            return date
        }
    }

    func checkForNewNotifications(_ done: @escaping BasicBlock = {}) {
        let storedKey = StreamKind.notifications(category: nil).lastViewedCreatedAtKey!
        let storedDate = GroupDefaults[storedKey].date

        ElloProvider.shared.elloRequest(
            ElloAPI.notificationsNewContent(createdAt: storedDate),
            success: { (_, responseConfig) in
                if let statusCode = responseConfig.statusCode, statusCode == 204 {
                    postNotification(NewContentNotifications.newNotifications, value: ())
                }

                done()
            },
            failure: { _ in done() })
    }

    func checkForNewAnnouncements(_ done: @escaping BasicBlock = {}) {
        let storedKey = StreamKind.announcements.lastViewedCreatedAtKey!
        let storedDate = GroupDefaults[storedKey].date

         ElloProvider.shared.elloRequest(
             ElloAPI.announcementsNewContent(createdAt: storedDate),
             success: { (_, responseConfig) in
                 if let statusCode = responseConfig.statusCode, statusCode == 204 {
                     postNotification(NewContentNotifications.newAnnouncements, value: ())
                 }

                 done()
             },
             failure: { _ in done() })
    }

    func checkForNewFollowingContent(_ done: @escaping BasicBlock = {}) {
        let storedKey = StreamKind.following.lastViewedCreatedAtKey!
        let storedDate = GroupDefaults[storedKey].date

        ElloProvider.shared.elloRequest(
            ElloAPI.followingNewContent(createdAt: storedDate),
            success: { (_, responseConfig) in
                if let lastModified = responseConfig.lastModified {
                    GroupDefaults[storedKey] = lastModified.toDate(HTTPDateFormatter)
                }

                if let statusCode = responseConfig.statusCode, statusCode == 204 {
                    postNotification(NewContentNotifications.newFollowingContent, value: ())
                }

                done()
            },
            failure: { _ in done() })
    }
}
