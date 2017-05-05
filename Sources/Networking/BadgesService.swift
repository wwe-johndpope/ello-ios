////
///  BadgesService.swift
//

import Alamofire
import SwiftyJSON


class BadgesService {
    static var badges: [String: Badge] = {
        if let data = readBadgesData(),
            let badges = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: Badge]
        {
            return badges
        }
        return [:]
    }()

    private static func readBadgesData() -> Data? {
        guard let fileURL = self.fileURL() else { return nil }
        return (try? Data(contentsOf: fileURL))
    }

    private static func saveBadgesData(_ data: Data) {
        guard let fileURL = self.fileURL() else { return }
        try? data.write(to: fileURL, options: [.atomic])
    }

    private static func fileURL() -> URL? {
        if let pathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return pathURL.appendingPathComponent("badges.data")
        }
        return nil
    }

    static func loadStaticBadges() {
        Alamofire.request("\(ElloURI.baseURL)/api/v2/badges.json")
            .responseJSON { response in
                guard
                    let jsonObject = response.result.value as? [String: Any],
                    let badgesJson = jsonObject["badges"] as? [[String: Any]]
                else { return }

                var badges: [String: Badge] = [:]
                for json in badgesJson {
                    guard let slug = json["slug"] as? String else { continue }
                    badges[slug] = Badge.fromJSON(json as [String : AnyObject]) as? Badge
                }

                BadgesService.badges = badges
                let data = NSKeyedArchiver.archivedData(withRootObject: badges)
                saveBadgesData(data)
            }
    }
}
