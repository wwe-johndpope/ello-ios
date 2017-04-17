////
///  ShareTrackerOverrides.swift
//

import Foundation


enum ContentType: String {
    case post = "Post"
    case comment = "Comment"
    case user = "User"
}

class Tracker {
    static let shared = Tracker()

    init() {}

    func contentFlagged(_ type: ContentType, flag: ContentFlagger.AlertOption, contentId: String) {}
    func contentFlaggingFailed(_ type: ContentType, message: String, contentId: String) {}
    func contentFlaggingCanceled(_ type: ContentType, contentId: String) {}
    func encounteredNetworkError(_ path: String, error: NSError, statusCode: Int?) {}
}

class Window {
    static func columnCountFor(width: CGFloat) -> Int { return 1 }
    static func isWide(_ width: Float) -> Bool { return false }
    static var width: Float { return 0 }
}

class DeviceScreen {
    static var isRetina: Bool { return true }
    static var scale: Float { return 2 }
}
