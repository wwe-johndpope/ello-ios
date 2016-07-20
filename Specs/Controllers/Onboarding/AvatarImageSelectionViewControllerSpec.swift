////
///  AvatarImageSelectionViewControllerSpec.swift
//

@testable
import Ello
import Quick
import Nimble
import Nimble_Snapshots


class AvatarImageSelectionViewControllerSpec: QuickSpec {
    override func spec() {
        describe("AvatarImageSelectionViewController") {
            let subject = AvatarImageSelectionViewController()
            describe("snapshots") {
                validateAllSnapshots(subject, named: "AvatarImageSelectionViewController")
            }
        }
    }
}
