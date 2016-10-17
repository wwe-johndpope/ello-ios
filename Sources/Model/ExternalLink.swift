////
///  ExternalLink.swift
//


public struct ExternalLink {
    public let url: NSURL
    public let text: String
    public let iconURL: NSURL?

    public init(url: NSURL, text: String, iconURL: NSURL? = nil) {
        self.url = url
        self.text = text
        self.iconURL = iconURL
    }
}

public extension ExternalLink {
    static func fromDict(link: [String: String]) -> ExternalLink? {
        guard let
            urlStr = link["url"],
            url = NSURL(string: urlStr),
            text = link["text"]
        else {
            return nil
        }

        let iconURL: NSURL?
        if let iconURLStr = link["icon"] {
            iconURL = NSURL(string: iconURLStr)
        }
        else {
            iconURL = nil
        }
        return ExternalLink(url: url, text: text, iconURL: iconURL)
    }

    func toDict() -> [String: String] {
        var retVal: [String: String] = [
            "url": url.absoluteString ?? "",
            "text": text
        ]
        if let iconURL = iconURL {
            retVal["icon"] = iconURL.absoluteString ?? ""
        }
        return retVal
    }
}
