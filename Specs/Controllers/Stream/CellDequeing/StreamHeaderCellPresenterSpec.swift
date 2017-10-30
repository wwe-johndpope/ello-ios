////
///  StreamHeaderCellPresenterSpec.swift
//

@testable import Ello
import Quick
import Nimble


class StreamHeaderCellPresenterSpec: QuickSpec {
    override func spec() {
        describe("StreamHeaderCellPresenter") {
            let currentUser: User = stub(["username": "ello"])
            var cell: StreamHeaderCell!
            var item: StreamCellItem!

            beforeEach {
                StreamKind.following.setIsGridView(false)
            }

            context("when item is a Post Header") {
                beforeEach {
                    let post: Post = stub([
                        "author": currentUser,
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "lovesCount": 14,
                        "createdAt": Date(timeIntervalSinceNow: -1000),
                    ])

                    cell = StreamHeaderCell.loadFromNib() as StreamHeaderCell
                    item = StreamCellItem(jsonable: post, type: .streamHeader)
                }

                it("sets timeStamp") {
                    cell.timeStamp = ""
                    StreamHeaderCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: currentUser)
                    expect(cell.timeStamp) == "17m"
                }
                it("sets usernameButton title") {
                    cell.usernameButton.setTitle("", for: .normal)
                    StreamHeaderCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: currentUser)
                    expect(cell.usernameButton.currentTitle) == "@ello"
                }
                it("hides repostAuthor") {
                    StreamHeaderCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: currentUser)
                    expect(cell.repostedByButton.isHidden) == true
                    expect(cell.repostIconView.isHidden) == true
                }

                context("gridLayout streamKind") {

                    beforeEach {
                        StreamKind.following.setIsGridView(true)
                    }

                    it("sets isGridLayout") {
                        cell.isGridLayout = false
                        StreamHeaderCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: currentUser)
                        expect(cell.isGridLayout) == true
                    }

                    it("sets avatarHeight") {
                        cell.avatarHeight = 0
                        StreamHeaderCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: currentUser)
                        expect(cell.avatarHeight) == 30.0
                    }
                }

                context("not-gridLayout streamKind") {
                    it("sets isGridLayout") {
                        cell.isGridLayout = true
                        StreamHeaderCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: currentUser)
                        expect(cell.isGridLayout) == false
                    }

                    it("sets avatarHeight") {
                        cell.avatarHeight = 0
                        StreamHeaderCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: currentUser)
                        expect(cell.avatarHeight) == 40
                    }
                }
            }

            context("when item is a Post Header with repostAuthor") {
                beforeEach {
                    let repostAuthor: User = stub([
                        "id": "reposterId",
                        "username": "reposter",
                        "relationshipPriority": RelationshipPriority.following.rawValue,
                    ])
                    let post: Post = stub([
                        "author": currentUser,
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "lovesCount": 14,
                        "repostAuthor": repostAuthor,
                    ])

                    cell = StreamHeaderCell.loadFromNib() as StreamHeaderCell
                    item = StreamCellItem(jsonable: post, type: .streamHeader)
                }
                it("sets relationshipControl properties") {
                    cell.relationshipControl.userId = ""
                    cell.relationshipControl.userAtName = ""
                    cell.relationshipControl.relationshipPriority = RelationshipPriority.null
                    StreamHeaderCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: currentUser)
                    expect(cell.relationshipControl.userId) == "reposterId"
                    expect(cell.relationshipControl.userAtName) == "@reposter"
                    expect(cell.relationshipControl.relationshipPriority) == RelationshipPriority.following
                }
                it("sets followButtonVisible") {
                    cell.followButtonVisible = true
                    StreamHeaderCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: currentUser)
                    expect(cell.followButtonVisible) == false
                }

                context("gridLayout streamKind") {
                    it("shows reposter and author") {
                        StreamHeaderCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: currentUser)
                        expect(cell.repostedByButton.isHidden) == false
                        expect(cell.repostIconView.isHidden) == false
                    }
                }

                context("not-gridLayout streamKind") {
                    it("shows author and repostAuthor") {
                        StreamHeaderCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: currentUser)
                        expect(cell.repostedByButton.currentTitle) == "by @ello"
                        expect(cell.repostedByButton.isHidden) == false
                        expect(cell.repostIconView.isHidden) == false
                    }
                }
            }

            context("when item is a Post Header with author and PostDetail streamKind") {
                let postId = "768"
                beforeEach {
                    let author: User = stub([
                        "id": "authorId",
                        "username": "author",
                        "relationshipPriority": RelationshipPriority.following.rawValue,
                    ])
                    let post: Post = stub([
                        "id": postId,
                        "author": author,
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "lovesCount": 14,
                    ])

                    cell = StreamHeaderCell.loadFromNib() as StreamHeaderCell
                    item = StreamCellItem(jsonable: post, type: .streamHeader)
                }
                it("sets followButtonVisible") {
                    cell.followButtonVisible = false
                    StreamHeaderCellPresenter.configure(cell, streamCellItem: item, streamKind: .postDetail(postParam: postId), indexPath: IndexPath(item: 0, section: 0), currentUser: currentUser)
                    expect(cell.followButtonVisible) == true
                    expect(cell.relationshipControl.userId) == "authorId"
                    expect(cell.relationshipControl.userAtName) == "@author"
                    expect(cell.relationshipControl.relationshipPriority) == RelationshipPriority.following
                }
            }

            context("when item is a Post Header with repostAuthor and PostDetail streamKind") {
                let postId = "768"
                beforeEach {
                    let repostAuthor: User = stub([
                        "id": "reposterId",
                        "username": "reposter",
                        "relationshipPriority": RelationshipPriority.following.rawValue,
                    ])
                    let post: Post = stub([
                        "id": postId,
                        "repostAuthor": repostAuthor,
                    ])

                    cell = StreamHeaderCell.loadFromNib() as StreamHeaderCell
                    item = StreamCellItem(jsonable: post, type: .streamHeader)
                }
                it("sets followButtonVisible") {
                    cell.followButtonVisible = false
                    StreamHeaderCellPresenter.configure(cell, streamCellItem: item, streamKind: .postDetail(postParam: postId), indexPath: IndexPath(item: 0, section: 0), currentUser: currentUser)
                    expect(cell.followButtonVisible) == true
                    expect(cell.relationshipControl.userId) == "reposterId"
                    expect(cell.relationshipControl.userAtName) == "@reposter"
                    expect(cell.relationshipControl.relationshipPriority) == RelationshipPriority.following
                }
            }

            context("when item is a Post Header with Category and PostDetail streamKind") {
                beforeEach {
                    let category: Ello.Category = stub(["name": "Art"])
                    let post: Post = stub([
                        "author": currentUser,
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "lovesCount": 14,
                        "categories": [category],
                    ])

                    cell = StreamHeaderCell.loadFromNib() as StreamHeaderCell
                    item = StreamCellItem(jsonable: post, type: .streamHeader)
                }
                it("sets categoryButton in .Featured stream") {
                    cell.followButtonVisible = false
                    StreamHeaderCellPresenter.configure(cell, streamCellItem: item, streamKind: .discover(type: .featured), indexPath: IndexPath(item: 0, section: 0), currentUser: currentUser)
                    expect(cell.followButtonVisible) == false
                    expect(cell.relationshipControl.isHidden) == true
                    expect(cell.categoryButton.currentTitle) == "in Art"
                    expect(cell.categoryButton.isHidden) == false
                }
                it("hides categoryButton if not in .Featured stream") {
                    cell.followButtonVisible = false
                    StreamHeaderCellPresenter.configure(cell, streamCellItem: item, streamKind: .postDetail(postParam: ""), indexPath: IndexPath(item: 0, section: 0), currentUser: currentUser)
                    expect(cell.followButtonVisible) == false
                    expect(cell.relationshipControl.isHidden) == true
                    expect(cell.categoryButton.isHidden) == true
                }
            }

            context("when item is a Post Header with author and PostDetail streamKind, but currentUser is the author") {
                beforeEach {
                    let post: Post = stub([
                        "author": currentUser,
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "lovesCount": 14,
                        ])

                    cell = StreamHeaderCell.loadFromNib() as StreamHeaderCell
                    item = StreamCellItem(jsonable: post, type: .streamHeader)
                }
                it("sets followButtonVisible") {
                    cell.followButtonVisible = true
                    StreamHeaderCellPresenter.configure(cell, streamCellItem: item, streamKind: .postDetail(postParam: ""), indexPath: IndexPath(item: 0, section: 0), currentUser: currentUser)
                    expect(cell.followButtonVisible) == false
                }
            }


        }
    }
}
