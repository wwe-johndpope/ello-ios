////
///  DiscoverType.swift
//

public enum DiscoverType: String {
    case Featured = "recommended"
    case Trending = "trending"
    case Recent = "recent"

    static func fromURL(slug: String) -> DiscoverType? {
        switch slug {
        case "featured", "recommended", "":
            return .Featured
        case "trending":
            return .Trending
        case "recent":
            return .Recent
        default:
            return nil
        }
    }

    public var slug: String { return rawValue }
    public var name: String {
        switch self {
        case Featured: return InterfaceString.Discover.Featured
        case Trending: return InterfaceString.Discover.Trending
        case Recent: return InterfaceString.Discover.Recent
        }
    }
}
