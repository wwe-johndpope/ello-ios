////
///  SnapKitExtensions.swift
//

import SnapKit


enum Priority: ConstraintPriorityTarget {
    case high
    case medium
    case low
    case required

    var value: Float { return constraintPriorityTargetValue }
    var constraintPriorityTargetValue: Float {
        switch self {
        case .high: return UILayoutPriorityDefaultHigh
        case .medium: return (UILayoutPriorityDefaultHigh + UILayoutPriorityDefaultLow) / 2
        case .low: return UILayoutPriorityDefaultLow
        case .required: return UILayoutPriorityRequired
        }
    }

}
