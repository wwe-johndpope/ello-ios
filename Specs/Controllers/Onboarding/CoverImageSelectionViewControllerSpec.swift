////
///  CoverImageSelectionViewControllerSpec.swift
//

@testable
import Ello
import Quick
import FBSnapshotTestCase
import Nimble
import Nimble_Snapshots


class CoverImageSelectionViewControllerSpec: QuickSpec {
    override func spec() {
        describe("CoverImageSelectionViewController") {
            let subject = CoverImageSelectionViewController()
            validateAllSnapshots(subject)
        }
    }
}
