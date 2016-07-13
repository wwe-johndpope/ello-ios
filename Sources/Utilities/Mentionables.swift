////
///  Mentionables.swift
//

struct Mentionables {
    static func findAll(regions: [Regionable]) -> [String] {
        var mentions = [String]()
        let regex = Regex("\\B@[\\w-]+")!
        for region in regions {
            if let textRegion = region as? TextRegion {
                let matches = regex.matches(textRegion.content)
                mentions += matches
            }
        }
        return mentions
    }
}
