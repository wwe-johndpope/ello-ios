////
///  StreamViewDataChange.swift
//

import DeltaCalculator


enum StreamViewDataChange {
    static func == (lhs: StreamViewDataChange, rhs: StreamViewDataChange) -> Bool {
        if case .reloadAll = lhs, case .reloadAll = rhs {
            return true
        }
        return false
    }

    case reloadAll
    case block(Block)
    case delta(Delta)
}
