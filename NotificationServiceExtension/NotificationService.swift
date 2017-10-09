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
    }

    private func fetchPost(id: String, content: UNMutableNotificationContent) {
        PostService().loadPost(id)
            .thenFinally { post in
                guard let regions = post.notificationContent,
                    let contentHandler = self.contentHandler
                else { return }

                let downloadedImages: [URL] = regions.flatMap { region -> URL? in
                    switch region.kind {
                    case .image:
                        guard
                            let region = region as? ImageRegion,
                            let asset = region.asset
                        else { return nil }

                        let attachment: Attachment?
                        if asset.isSmallGif {
                            attachment = asset.original
                        }
                        else {
                            attachment = asset.hdpi
                        }

                        guard
                            let url = attachment?.url,
                            let data = try? Data(contentsOf: url)
                        else { return nil }

                        return Tmp.write(data, to: url.lastPathComponent)
                    default:
                        return nil
                    }
                }

                content.attachments = downloadedImages.flatMap { location -> UNNotificationAttachment? in
                    let identifier = "region-\(location.lastPathComponent)"
                    let attachment = try? UNNotificationAttachment(identifier: identifier, url: location, options: nil)
                    return attachment
                }
                contentHandler(content)
            }
            .ignoreErrors()
    }

    private func fetchUser(id: String, content: UNMutableNotificationContent) {
        contentHandler?(content)
    }

    override func serviceExtensionTimeWillExpire() {
        contentHandler = nil
        // guard let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent else { return }

        // contentHandler(bestAttemptContent)
    }

}
