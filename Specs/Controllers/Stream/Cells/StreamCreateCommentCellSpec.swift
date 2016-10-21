////
///  StreamCreateCommentCellSpec.swift
//

@testable import Ello
import Quick
import Nimble


class StreamCreateCommentCellSpec: QuickSpec {
    override func spec() {
        describe("StreamCreateCommentCell") {
            var subject: StreamCreateCommentCell!
            beforeEach {
                subject = StreamCreateCommentCell()
                subject.avatarView.image = UIImage.imageWithColor(.blueColor())!
            }
            describe("snapshots") {
                it("has a valid default") {
                    subject.watchVisibility = .Hidden
                    subject.replyAllVisibility = .Hidden
                    expectValidSnapshot(subject, device: .Custom(CGSize(width: 375, height: StreamCellType.CreateComment.oneColumnHeight)))
                }
                it("has a valid reply all button") {
                    subject.watchVisibility = .Hidden
                    subject.replyAllVisibility = .Enabled
                    expectValidSnapshot(subject, device: .Custom(CGSize(width: 375, height: StreamCellType.CreateComment.oneColumnHeight)))
                }
                it("has a valid not-watching button") {
                    subject.watchVisibility = .Enabled
                    subject.replyAllVisibility = .Hidden
                    subject.watching = false
                    expectValidSnapshot(subject, device: .Custom(CGSize(width: 375, height: StreamCellType.CreateComment.oneColumnHeight)))
                }
                it("has a valid watching button") {
                    subject.watchVisibility = .Enabled
                    subject.replyAllVisibility = .Hidden
                    subject.watching = true
                    expectValidSnapshot(subject, device: .Custom(CGSize(width: 375, height: StreamCellType.CreateComment.oneColumnHeight)))
                }
            }
        }
    }
}
