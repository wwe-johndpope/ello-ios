////
///  ElloAPISharingHeaders.swift
//

extension ElloAPI {
    var sharingHeaders: [String: String]? {
        switch self {
        case .CreatePost:
            return ["X-Segment-Event": "share-event"]
        default:
            return nil
        }
    }
}
