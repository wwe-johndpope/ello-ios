////
///  ShareExtensionHeaders.swift
//

extension ElloAPI {
    var extensionHeaders: [String: String]? {
        switch self {
        case .createPost:
            return ["X-Segment-Event": "share-event"]
        default:
            return nil
        }
    }
}
