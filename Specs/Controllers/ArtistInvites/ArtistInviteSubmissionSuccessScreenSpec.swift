////
///  ArtistInviteSubmissionSuccessScreenSpec.swift
//

@testable import Ello
import Quick
import Nimble


class ArtistInviteSubmissionSuccessScreenSpec: QuickSpec {
    override func spec() {
        describe("ArtistInviteSubmissionSuccessScreen") {
            describe("snapshots") {
                let subject = ArtistInviteSubmissionSuccessScreen()
                validateAllSnapshots(named: "ArtistInviteSubmissionSuccessScreen") { return subject }
            }
        }
    }
}
