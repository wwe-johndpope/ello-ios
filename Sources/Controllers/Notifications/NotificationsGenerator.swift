////
///  NotificationsGenerator.swift
//

import PromiseKit


final class NotificationsGenerator: StreamGenerator {
    var currentUser: User?
    var streamKind: StreamKind

    fileprivate var notificationActivities: [Activity] = []
    fileprivate var announcements: [Announcement] = []
    fileprivate var hasNotifications: Bool?

    weak var destination: StreamDestination?

    fileprivate var localToken: String = ""
    fileprivate var loadingToken = LoadingToken()

    init(
        currentUser: User?,
        streamKind: StreamKind,
        destination: StreamDestination?
        ) {
        self.currentUser = currentUser
        self.streamKind = streamKind
        self.destination = destination
    }

    func load(reload: Bool = false) {
        localToken = loadingToken.resetInitialPageLoadingToken()

        if reload {
            announcements = []
            notificationActivities = []
        }
        else {
            setPlaceHolders()
        }

        loadAnnouncements()
        loadNotifications()
    }

    func reloadAnnouncements() {
        loadAnnouncements()
    }

    func setPlaceHolders() {
        destination?.setPlaceholders(items: [
            StreamCellItem(type: .placeholder, placeholderType: .announcements),
            StreamCellItem(type: .placeholder, placeholderType: .notifications),
        ])
    }

    func markAnnouncementAsRead(_ announcement: Announcement) {
        NotificationService().markAnnouncementAsRead(announcement)
            .thenFinally { [weak self] _ in
                self?.announcements = []
            }
            .catch { _ in }
    }

    func loadAnnouncements() {
        guard case let .notifications(category) = streamKind, category == nil else {
            compareAndUpdateAnnouncements([])
            return
        }

        NotificationService().loadAnnouncements()
            .thenFinally { [weak self] announcement in
                guard let `self` = self else { return }
                guard self.loadingToken.isValidInitialPageLoadingToken(self.localToken) else { return }

                if let announcement = announcement {
                    self.compareAndUpdateAnnouncements([announcement])
                }
                else {
                    self.compareAndUpdateAnnouncements([])
                }
            }
            .catch { [weak self] _ in
                self?.compareAndUpdateAnnouncements([])
            }
    }

    fileprivate func compareAndUpdateAnnouncements(_ newAnnouncements: [Announcement]) {
        guard !announcementsAreSame(newAnnouncements) else { return }

        self.announcements = newAnnouncements
        let announcementItems = StreamCellItemParser().parse(newAnnouncements, streamKind: .announcements, currentUser: self.currentUser)
        self.destination?.replacePlaceholder(type: .announcements, items: announcementItems)
    }

    func announcementsAreSame(_ newAnnouncements: [Announcement]) -> Bool {
        return announcements.count == newAnnouncements.count && announcements.enumerated().all({ (index, announcement) in
            return announcement.id == newAnnouncements[index].id
        })
    }

    func loadNotifications() {
        StreamService().loadStream(streamKind: streamKind)
            .thenFinally { [weak self] response in
                guard
                    let `self` = self,
                    self.loadingToken.isValidInitialPageLoadingToken(self.localToken)
                else { return }

                switch response {
                case let .jsonables(jsonables, responseConfig):
                    guard
                        let notificationActivities = jsonables as? [Activity]
                    else { return }

                    self.notificationActivities = notificationActivities
                    // setting primaryJSONAble also triggers the "done loading" code
                    self.destination?.setPrimary(jsonable: JSONAble(version: JSONAbleVersion))
                    self.destination?.setPagingConfig(responseConfig: responseConfig)

                    self.loadExtraNotificationContent(notificationActivities)
                        .thenFinally {
                            let notificationItems = self.parse(jsonables: notificationActivities)
                            if notificationItems.count == 0 {
                                let noContentItem = StreamCellItem(type: .emptyStream(height: 282))
                                self.hasNotifications = false
                                self.destination?.replacePlaceholder(type: .notifications, items: [noContentItem]) {
                                    self.destination?.isPagingEnabled = false
                                }
                            }
                            else {
                                self.hasNotifications = true
                                self.destination?.replacePlaceholder(type: .notifications, items: notificationItems) {
                                    self.destination?.isPagingEnabled = true
                                }
                            }
                        }
                        .ignoreErrors()
                case .empty:
                    let noContentItem = StreamCellItem(type: .emptyStream(height: 282))
                    self.destination?.setPrimary(jsonable: JSONAble(version: JSONAbleVersion))
                    self.destination?.replacePlaceholder(type: .notifications, items: [noContentItem]) {
                        self.destination?.isPagingEnabled = false
                    }
                }
            }
            .catch { [weak self] _ in
                self?.destination?.primaryJSONAbleNotFound()
            }
    }

    fileprivate func loadExtraNotificationContent(_ notificationActivities: [Activity]) -> Promise<Void> {
        let (promise, resolve, _) = Promise<Void>.pending()
        let (afterAll, done) = afterN {
            resolve(Void())
        }
        for activity in notificationActivities {
            guard let submission = activity.subject as? ArtistInviteSubmission, submission.artistInvite == nil else { continue }

            let next = afterAll()
            ArtistInviteService().load(id: submission.artistInviteId)
                .thenFinally { artistInvite in
                    ElloLinkedStore.sharedInstance.setObject(artistInvite, forKey: submission.artistInviteId, type: .artistInvitesType)
                    print("submission.artistInvite: \(submission.artistInvite?.description ?? "nil")")
                }
                .always { _ in next() }
        }
        done()
        return promise
    }
}
