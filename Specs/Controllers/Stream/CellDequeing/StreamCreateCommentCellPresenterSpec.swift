////
///  StreamCreateCommentCellPresenterSpec.swift
//

@testable import Ello
import Quick
import Nimble


class StreamCreateCommentCellPresenterSpec: QuickSpec {
    enum PostOwnership {
        case OtherPost
        case MyPost
        case MyRepostOtherPost
        case OtherRepostMyPost
        case OtherRepostOtherPost
    }

    override func spec() {
        describe("StreamCreateCommentCellPresenter") {
            context("replyAll and watch button visibility") {
                let expectations: [(postOwner: PostOwnership, canWatch: Bool, canReplyAll: Bool)] = [
                    (postOwner: .OtherPost, canWatch: true, canReplyAll: false),
                    (postOwner: .MyPost, canWatch: false, canReplyAll: true),
                    (postOwner: .MyRepostOtherPost, canWatch: false, canReplyAll: true),
                    (postOwner: .OtherRepostMyPost, canWatch: false, canReplyAll: false),
                    (postOwner: .OtherRepostOtherPost, canWatch: true, canReplyAll: false),
                ]
                for (postOwner, canWatch, canReplyAll) in expectations {
                    context("post owner \(postOwner)") {
                        let currentUser: User = stub(["id": "me"])
                        let otherUser: User = stub(["id": "other"])
                        var post: Post!
                        var comment: ElloComment!
                        var cell: StreamCreateCommentCell!
                        var item: StreamCellItem!
                        beforeEach {
                            switch postOwner {
                            case .OtherPost:
                                post = Post.stub(["author": otherUser])
                            case .MyPost:
                                post = Post.stub(["author": currentUser])
                            case .MyRepostOtherPost:
                                post = Post.stub(["author": currentUser, "repostAuthor": otherUser, "repostContent": [TextRegion(content: "")]])
                            case .OtherRepostMyPost:
                                post = Post.stub(["author": otherUser, "repostAuthor": currentUser, "repostContent": [TextRegion(content: "")]])
                            case .OtherRepostOtherPost:
                                post = Post.stub(["author": otherUser, "repostAuthor": otherUser, "repostContent": [TextRegion(content: "")]])
                            }
                            comment = ElloComment.stub(["loadedFromPost": post])
                            item = StreamCellItem(jsonable: comment, type: .CreateComment)
                            cell = StreamCreateCommentCell()
                        }
                        it("cell \(canWatch ? "can" : "cannot") watch") {
                            StreamCreateCommentCellPresenter.configure(cell, streamCellItem: item, streamKind: .Following, indexPath: NSIndexPath(forItem: 0, inSection: 0), currentUser: currentUser)
                            expect(cell.watchVisibility == .Enabled) == canWatch
                        }
                        it("cell \(canReplyAll ? "can" : "cannot") reply all") {
                            StreamCreateCommentCellPresenter.configure(cell, streamCellItem: item, streamKind: .Following, indexPath: NSIndexPath(forItem: 0, inSection: 0), currentUser: currentUser)
                            expect(cell.replyAllVisibility == .Enabled) == canReplyAll
                        }
                    }
                }
            }
        }
    }
}
