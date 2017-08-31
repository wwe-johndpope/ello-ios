////
///  StreamViewDataChange.swift
//

import DeltaCalculator


enum StreamViewDataChange {
    case reload
    case update(StreamViewController.CollectionViewChange)
    case batch(StreamViewController.CollectionViewChange)
    case delta(Delta)
}
