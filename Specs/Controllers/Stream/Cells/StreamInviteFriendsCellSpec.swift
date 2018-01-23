////
///  StreamInviteFriendsCellSpec.swift
//

@testable import Ello
import Quick
import Nimble

class StreamInviteFriendsCellSpec: QuickSpec {

    override func spec() {
        var subject: StreamInviteFriendsCell!

        beforeEach {
            subject = StreamInviteFriendsCell.loadFromNib()
        }

        describe("StreamInviteFriendsCell") {
            it("IBOutlets are not nil") {
                expect(subject.inviteButton).notTo(beNil())
                expect(subject.nameLabel).notTo(beNil())
            }
        }
    }

}
