////
///  NotificationService.swift
//

import FutureKit


public class NotificationService {

    public init() {}

    public func loadAnnouncements() -> Future<Announcement> {
        let promise = Promise<Announcement>()
        ElloProvider.shared.elloRequest(
            .Announcements,
            success: { (data, responseConfig) in
                if let results = data as? Announcement {
                    promise.completeWithSuccess(results)
                }
                else {
                    let error = NSError.uncastableJSONAble()
                    promise.completeWithFail(error)
                }
            },
            failure: { error, _ in
                promise.completeWithFail(error)
            }
        )
        return promise.future
    }

    public func markAnnouncementAsRead(_ announcement: Announcement) -> Future<Announcement> {
        let promise = Promise<Announcement>()
        ElloProvider.shared.elloRequest(.MarkAnnouncementAsRead,
            success: { _ in
                promise.completeWithSuccess(announcement)
            },
            failure: { error, _ in
                promise.completeWithFail(error)
            }
        )
        return promise.future
    }

}
