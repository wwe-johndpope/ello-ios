////
///  ProfileHeaderGhostCellSpec.swift
//

@testable import Ello
import Quick
import Nimble


class ProfileHeaderGhostCellSpec: QuickSpec {
    override func spec() {
        fdescribe("ProfileHeaderGhostCell") {
            it("snapshot") {
                let subject = ProfileHeaderGhostCell()
                expectValidSnapshot(subject, named: "ProfileHeaderGhostCell", device: .Custom(CGSize(width: 375, height: ProfileHeaderGhostCell.Size.height)))
            }
        }
    }
}
