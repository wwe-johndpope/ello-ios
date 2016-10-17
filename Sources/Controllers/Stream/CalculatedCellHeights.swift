////
///  CalculatedCellHeights.swift
//

public struct CalculatedCellHeights {
    public enum Prop {
        case OneColumn
        case MultiColumn
        case WebContent
        case ProfileNames
        case ProfileBio
        case ProfileLinks
    }

    public var oneColumn: CGFloat?
    public var multiColumn: CGFloat?
    public var webContent: CGFloat?
    public var profileNames: CGFloat?
    public var profileBio: CGFloat?
    public var profileLinks: CGFloat?
}
