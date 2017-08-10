////
///  NotificationService.swift
//

import UserNotifications
import Alamofire


class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        guard
            let path = request.content.userInfo["application_target"] as? String,
            let content = (request.content.mutableCopy() as? UNMutableNotificationContent)
        else { return }

        self.contentHandler = contentHandler

        let (type, data) = ElloURI.match(path)

        switch type {
        case .pushNotificationComment:
            fetchPost(id: data, content: content)
        case .pushNotificationPost:
            fetchPost(id: data, content: content)
        case .pushNotificationUser:
            fetchUser(id: data, content: content)
        default:
            return
        }

        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"

            contentHandler(bestAttemptContent)
        }
    }

    private func fetchPost(id: String, content: UNMutableNotificationContent) {
        content.title = "\(content.title) [post \(id)]"
        PostService().loadPost(id)
            .thenFinally { post in
                guard let regions = post.notificationContent else { return }

                var downloadedImages: [(order: Int, data: Data, name: String)] = []

                let (afterAll, done) = afterN() {
                    guard let contentHandler = self.contentHandler else { return }

                    let images = downloadedImages.sorted { $0.order < $1.order }
                    content.attachments = images.flatMap { entry -> UNNotificationAttachment? in
                        let identifier = "region-\(entry.order)-\(entry.name)"
                        guard let url = Tmp.write(entry.data, to: identifier) else { return nil }
                        return try? UNNotificationAttachment(identifier: identifier, url: url, options: nil)
                    }
                    contentHandler(content)
                }

                for (index, region) in regions.enumerated() {
                    switch region.kind {
                    case .image:
                        guard let region = region as? ImageRegion,
                            let url = region.asset?.largeOrBest?.url
                        else { continue }

                        let next = afterAll()
                        Alamofire.download(url).responseData { response in
                            if let data = response.result.value {
                                downloadedImages.append((order: index, data: data, name: url.lastPathComponent))
                            }
                            next()
                        }
                    default: break
                    }
                }

                done()
            }
            .ignoreErrors()
    }

    private func fetchUser(id: String, content: UNMutableNotificationContent) {
        content.title = "\(content.title) [user \(id)]"
        contentHandler?(content)
    }

    override func serviceExtensionTimeWillExpire() {
        contentHandler = nil
        // guard let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent else { return }

        // contentHandler(bestAttemptContent)
    }

}
