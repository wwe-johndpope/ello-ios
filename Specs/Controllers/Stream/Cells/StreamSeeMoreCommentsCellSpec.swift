////
///  StreamSeeMoreCommentsCellSpec.swift
//

@testable import Ello
import Quick
import Nimble

class StreamSeeMoreCommentsCellSpec: QuickSpec {

    override func spec() {

        var subject: StreamSeeMoreCommentsCell!
        beforeEach {
            subject = StreamSeeMoreCommentsCell.loadFromNib()
        }

        describe("StreamSeeMoreComments") {
            it("sets IBOutlets") {
                expect(subject.buttonContainer).notTo(beNil())
                expect(subject.seeMoreButton).notTo(beNil())
            }
        }

    }

}
