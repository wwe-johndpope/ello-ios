////
///  NotificationsGenerator.swift
//

public final class NotificationsGenerator: StreamGenerator {
    public var currentUser: User?
    public var streamKind: StreamKind

    private var notifications: [Activity] = []
    private var announcements: [Announcement] = []
    private var hasNotifications: Bool?

    weak public var destination: StreamDestination?

    private var localToken: String!
    private var loadingToken = LoadingToken()

    public init(
        currentUser: User?,
        streamKind: StreamKind,
        destination: StreamDestination?
        ) {
        self.currentUser = currentUser
        self.streamKind = streamKind
        self.destination = destination
        self.localToken = loadingToken.resetInitialPageLoadingToken()
    }

    public func load(reload reload: Bool = false) {
        localToken = loadingToken.resetInitialPageLoadingToken()

        if reload {
            announcements = []
            notifications = []
        }
        else {
            setPlaceHolders()
        }

        loadAnnouncements()
        loadNotifications()
    }

    public func reloadAnnouncements() {
        loadAnnouncements()
    }

    func setPlaceHolders() {
        destination?.setPlaceholders([
            StreamCellItem(type: .Placeholder, placeholderType: .Announcements),
            StreamCellItem(type: .Placeholder, placeholderType: .Notifications),
        ])
    }

    func markAnnouncementAsRead(_ announcement: Announcement) {
        NotificationService().markAnnouncementAsRead(announcement)
            .onSuccess { [weak self] _ in
                self?.announcements = []
            }
            .onFail { _ in }
    }

    func loadAnnouncements() {
        guard case let .Notifications(category) = streamKind
        where category == nil else {
            compareAndUpdateAnnouncements([])
            return
        }

        NotificationService().loadAnnouncements()
            .onSuccess { [weak self] announcement in
                guard let sself = self else { return }
                guard sself.loadingToken.isValidInitialPageLoadingToken(sself.localToken) else { return }

                if let announcement = announcement {
                    sself.compareAndUpdateAnnouncements([announcement])
                }
                else {
                    sself.compareAndUpdateAnnouncements([])
                }
            }
            .onFail { [weak self] _ in
                self?.compareAndUpdateAnnouncements([])
            }
    }

    private func compareAndUpdateAnnouncements(_ newAnnouncements: [Announcement]) {
        guard !announcementsAreSame(newAnnouncements) else { return }

        self.announcements = newAnnouncements
        let announcementItems = StreamCellItemParser().parse(newAnnouncements, streamKind: .Announcements, currentUser: self.currentUser)
        self.destination?.replacePlaceholder(.Announcements, items: announcementItems) {}
    }

    func announcementsAreSame(newAnnouncements: [Announcement]) -> Bool {
        return announcements.count == newAnnouncements.count && announcements.enumerate().all({ (index, announcement) in
            return announcement.id == newAnnouncements[index].id
        })
    }

    func loadNotifications() {
        StreamService().loadStream(
            streamKind: streamKind,
            success: { [weak self] (jsonables, responseConfig) in
                guard let sself = self else { return }
                guard sself.loadingToken.isValidInitialPageLoadingToken(sself.localToken) else { return }
                guard let notifications = jsonables as? [Activity] else { return }

                sself.notifications = notifications
                // setting primaryJSONAble also triggers the "done loading" code
                sself.destination?.setPrimaryJSONAble(JSONAble(version: JSONAbleVersion))
                sself.destination?.setPagingConfig(responseConfig)

                let notificationItems = sself.parse(notifications)
                if notificationItems.count == 0 {
                    sself.hasNotifications = false
                    sself.destination?.replacePlaceholder(.Notifications, items: []) {
                        sself.destination?.pagingEnabled = false
                    }
                }
                else {
                    sself.hasNotifications = true
                    sself.destination?.replacePlaceholder(.Notifications, items: notificationItems) {
                        sself.destination?.pagingEnabled = true
                    }
                }
            },
            failure: { [weak self] _ in
                self?.destination?.primaryJSONAbleNotFound()
            },
            noContent: { [weak self] in
                self?.destination?.primaryJSONAbleNotFound()
            }
        )
    }
}
