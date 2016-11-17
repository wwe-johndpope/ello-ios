////
///  CategoryLevel.swift
//

public enum CategoryLevel: String, Equatable {
    case Meta = "meta"
    case Primary = "primary"
    case Secondary = "secondary"
    case Tertiary = "tertiary"
    case Unknown = ""

    var order: Int {
        switch self {
        case Meta: return 0
        case Primary: return 1
        case Secondary: return 2
        case Tertiary: return 3
        case Unknown: return 1_048_576
        }
    }
}

public func == (lhs: CategoryLevel, rhs: CategoryLevel) -> Bool {
    return lhs.rawValue == rhs.rawValue
}
