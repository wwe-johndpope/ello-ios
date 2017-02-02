////
///  Defaults.swift
//

import Foundation

let ElloGroupName = "group.ello.Ello"
let GroupDefaults = defaults()

private func defaults() -> UserDefaults {
    if AppSetup.sharedState.isTesting {
        return UserDefaults.standard
    }

    return UserDefaults(suiteName: ElloGroupName) ?? UserDefaults.standard
}

extension UserDefaults {
    func resetOnLogout() {
        let groupDefaultResetKeys = [
            CurrentStreamKey,
            "ElloImageUploadQuality",
            StreamKind.notifications(category: nil).lastViewedCreatedAtKey,
            StreamKind.announcements.lastViewedCreatedAtKey,
            StreamKind.following.lastViewedCreatedAtKey,
        ]
        for key in groupDefaultResetKeys {
            self[key] = nil
        }
    }
}
