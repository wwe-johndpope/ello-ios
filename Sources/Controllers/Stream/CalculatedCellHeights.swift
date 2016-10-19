////
///  CalculatedCellHeights.swift
//

public struct CalculatedCellHeights {
    public enum Prop {
        case OneColumn
        case MultiColumn
        case WebContent
        case ProfileAvatar
        case ProfileNames
        case ProfileTotalCount
        case ProfileStats
        case ProfileBio
        case ProfileLinks
    }

    mutating func assign(prop: Prop, height: CGFloat) {
        switch prop {
        case .ProfileAvatar:
            profileAvatar = height
        case .ProfileNames:
            profileNames = height
        case .ProfileTotalCount:
            profileTotalCount = height
        case .ProfileStats:
            profileStats = height
        case .ProfileBio:
            profileBio = height
        case .ProfileLinks:
            profileLinks = height
        default: break
        }
    }

    public var oneColumn: CGFloat?
    public var multiColumn: CGFloat?
    public var webContent: CGFloat?
    public var profileAvatar: CGFloat?
    public var profileNames: CGFloat?
    public var profileTotalCount: CGFloat?
    public var profileStats: CGFloat?
    public var profileBio: CGFloat?
    public var profileLinks: CGFloat?
}
