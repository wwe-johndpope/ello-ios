////
///  NotificationService.swift
//

import UserNotifications
import Alamofire


class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var originalContent: UNNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        if let debugServer = DebugServer.fromDefaults {
            APIKeys.shared = debugServer.apiKeys
        }

        guard
            let path = request.content.userInfo["application_target"] as? String,
            let content = (request.content.mutableCopy() as? UNMutableNotificationContent)
        else {
            contentHandler(request.content)
            return
        }

        self.originalContent = request.content
        self.contentHandler = contentHandler

        let (type, data) = ElloURI.match(path)
        switch type {
        case .pushNotificationComment, .pushNotificationPost:
            fetchPost(id: data, content: content)
        default:
            contentHandler(request.content)
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
                    return try? UNNotificationAttachment(identifier: identifier, url: location, options: nil)
                }
                contentHandler(content)
            }
            .ignoreErrors()
    }

    override func serviceExtensionTimeWillExpire() {
        defer {
            self.originalContent = nil
            self.contentHandler = nil
        }

        guard let contentHandler = contentHandler, let originalContent = originalContent else { return }

        contentHandler(originalContent)
    }

}
