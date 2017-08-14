////
///  PushPayload.swift
//

struct PushPayload {
    let info: [String: Any]

    var destinationUserId: String? {
        if let id = (info["destination_user_id"] as? Int).map(String.init) { return id }
        return info["destination_user_id"] as? String
    }

    var applicationTarget: String {
        return info["application_target"] as? String ?? ""
    }

    var message: String {
        let aps = info["aps"] as? [String: Any]
        let alert = aps?["alert"] as? [String: String]
        return alert?["body"] ?? ""
    }
}

// {"application_target": "notifications/posts/6178", "destination_user_id": "12345", "aps": {"alert": {"body": "Hello, Ello!"}}}
// PushNotificationController.shared.receivedNotification(UIApplication.sharedApplication(), userInfo: ["application_target": "notifications/posts/6178", "aps": ["alert": ["body": "Hello, Ello!"]]])
