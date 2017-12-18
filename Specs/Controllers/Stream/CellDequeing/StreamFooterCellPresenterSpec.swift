@testable import Ello
import Quick
import Nimble

class StreamFooterCellPresenterSpec: QuickSpec {
    override func spec() {
        describe("configure") {
            var cell: StreamFooterCell!
            var item: StreamCellItem!
            var toolBar: UIToolbar!
            var post: Post!

            beforeEach {
                cell = StreamFooterCell()
                post = Post.stub([
                    "viewsCount": 9,
                    "repostsCount": 4,
                    "commentsCount": 6,
                    "lovesCount": 14
                ])
                item = StreamCellItem(jsonable: post, type: .streamFooter)
                toolBar = cell.specs().toolBar
            }

            context("single column view") {

                it("configures a stream footer cell") {
                    StreamKind.following.setIsGridView(false)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(cell.commentsControl.isSelected).to(beFalse())
                    expect(cell.commentsOpened).to(beFalse())
                    expect(cell.views) == "9"
                    expect(cell.reposts) == "4"
                    expect(cell.comments) == "6"
                    expect(cell.loves) == "14"
                }
            }

            context("grid layout") {

                it("configures a thin stream footer cell") {
                    cell.frame = CGRect(origin: .zero, size: CGSize(width: 150, height: 60))

                    StreamKind.following.setIsGridView(true)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(cell.commentsControl.isSelected).to(beFalse())
                    expect(cell.commentsOpened).to(beFalse())
                    expect(cell.views) == ""
                    expect(cell.reposts) == ""
                    expect(cell.comments) == "6"
                    expect(cell.loves) == ""
                }

                it("configures a wide stream footer cell") {
                    cell.frame = CGRect(origin: .zero, size: CGSize(width: 180, height: 60))

                    StreamKind.following.setIsGridView(true)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(cell.commentsControl.isSelected).to(beFalse())
                    expect(cell.commentsOpened).to(beFalse())
                    expect(cell.views) == "9"
                    expect(cell.reposts) == "4"
                    expect(cell.comments) == "6"
                    expect(cell.loves) == "14"
                }
            }

            context("detail streamkind") {

                it("configures a stream footer cell") {
                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .postDetail(postParam: post.id), indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(cell.commentsControl.isSelected).to(beTrue())
                    expect(cell.views) == "9"
                    expect(cell.reposts) == "4"
                    expect(cell.comments) == "6"
                    expect(cell.loves) == "14"

                    // details should have open comments
                    expect(cell.commentsOpened).to(beTrue())
                }
            }

            context("comment button") {

                it("usually enabled and visible") {
                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(toolBar.items).to(contain(cell.commentsItem))
                }

                it("shown if author allows it") {
                    let author: User = stub(["hasCommentingEnabled": true])
                    let post: Post = stub([
                        "author": author,
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(toolBar.items).to(contain(cell.commentsItem))
                }

                it("shown if author allows it in grid view") {
                    let author: User = stub(["hasCommentingEnabled": true])
                    let post: Post = stub([
                        "author": author,
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(toolBar.items).to(contain(cell.commentsItem))
                }

                it("hidden if author doesn't allow it") {
                    let author: User = stub(["hasCommentingEnabled": false])
                    let post: Post = stub([
                        "author": author,
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(toolBar.items).toNot(contain(cell.commentsItem))
                }

                it("hidden if author doesn't allow it in grid view") {
                    let author: User = stub(["hasCommentingEnabled": false])
                    let post: Post = stub([
                        "author": author,
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(toolBar.items).toNot(contain(cell.commentsItem))
                }
            }

            context("sharing button") {

                it("usually enabled and visible") {
                    let post: Post = stub([
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "lovesCount": 22
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamKind.following.setIsGridView(false)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(toolBar.items).to(contain(cell.shareItem))
                }

                it("shown if author allows it") {
                    let author: User = stub(["hasSharingEnabled": true])
                    let post: Post = stub([
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "author": author,
                        "lovesCount": 55
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(toolBar.items).to(contain(cell.shareItem))
                }

                it("never shown in grid view") {
                    let author: User = stub(["hasSharingEnabled": true])
                    let post: Post = stub([
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "author": author,
                        "lovesCount": 55
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)
                    StreamKind.following.setIsGridView(true)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(toolBar.items).notTo(contain(cell.shareItem))
                }

                it("hidden if author doesn't allow it") {
                    let author: User = stub(["hasSharingEnabled": false])
                    let post: Post = stub([
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "author": author,
                        "lovesCount": 55
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(toolBar.items).toNot(contain(cell.shareItem))
                }

                it("hidden if author doesn't allow it in grid view") {
                    let author: User = stub(["hasSharingEnabled": false])
                    let post: Post = stub([
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "author": author,
                        "lovesCount": 55
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(toolBar.items).toNot(contain(cell.shareItem))
                }
            }

            context("repost button") {

                it("usually enabled and visible") {
                    let user: User = stub([:])
                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: user)

                    expect(cell.repostControl.isEnabled).to(beTrue())
                    expect(toolBar.items).to(contain(cell.repostItem))
                }

                it("enabled if currentUser, post.author and post.repostAuthor are all nil") {
                    let post: Post = stub([
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "lovesCount": 55
                        ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(cell.repostControl.isEnabled).to(beTrue())
                    expect(toolBar.items).to(contain(cell.repostItem))
                }

                it("shown if author allows it") {
                    let author: User = stub(["hasRepostingEnabled": true])
                    let post: Post = stub([
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "author": author,
                        "lovesCount": 55
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(toolBar.items).to(contain(cell.repostItem))
                }

                it("shown if author allows it, in grid view") {
                    let author: User = stub(["hasRepostingEnabled": true])
                    let post: Post = stub([
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "author": author,
                        "lovesCount": 55
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(toolBar.items).to(contain(cell.repostItem))
                }

                it("disabled if current user already reposted") {
                    let author: User = stub(["hasRepostingEnabled": true])
                    let currentUser: User = stub([:])
                    let post: Post = stub([
                        "reposted": true,
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "author": author,
                        "lovesCount": 55
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: currentUser)

                    expect(cell.repostControl.isEnabled).to(beFalse())
                    expect(toolBar.items).to(contain(cell.repostItem))
                }

                it("hidden if author doesn't allow it") {
                    let author: User = stub(["hasRepostingEnabled": false])
                    let post: Post = stub([
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "author": author,
                        "lovesCount": 55
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(toolBar.items).toNot(contain(cell.repostItem))
                }

                it("hidden if author doesn't allow it, in grid view") {
                    let author: User = stub(["hasRepostingEnabled": false])
                    let post: Post = stub([
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "author": author,
                        "lovesCount": 55
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(toolBar.items).toNot(contain(cell.repostItem))
                }

                it("disabled if author is current user") {
                    let author: User = stub(["hasRepostingEnabled": true])
                    let post: Post = stub([
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "author": author,
                        "lovesCount": 55
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: author)

                    expect(cell.repostControl.isEnabled).to(beFalse())
                    expect(toolBar.items).to(contain(cell.repostItem))
                }

                it("disabled if author is repost author") {
                    let author: User = stub(["hasRepostingEnabled": true])
                    let repostAuthor: User = stub(["hasRepostingEnabled": true])
                    let post: Post = stub([
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "author": author,
                        "repostAuthor": repostAuthor,
                        "lovesCount": 55
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: repostAuthor)

                    expect(cell.repostControl.isEnabled).to(beFalse())
                    expect(toolBar.items).to(contain(cell.repostItem))
                }

                it("disabled if author is current user in grid view") {
                    let author: User = stub(["hasRepostingEnabled": true])
                    let post: Post = stub([
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "author": author,
                        "lovesCount": 55
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: author)

                    expect(cell.repostControl.isEnabled).to(beFalse())
                    expect(toolBar.items).to(contain(cell.repostItem))
                }

                it("hidden if author is current user, and reposting isn't allowed") {
                    let author: User = stub(["hasRepostingEnabled": false])
                    let post: Post = stub([
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "author": author,
                        "lovesCount": 55
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: author)

                    expect(toolBar.items).toNot(contain(cell.repostItem))
                }

                it("hidden if author is current user, and reposting isn't allowed in grid view") {
                    let author: User = stub(["hasRepostingEnabled": false])
                    let post: Post = stub([
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "author": author,
                        "lovesCount": 55
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: author)

                    expect(toolBar.items).toNot(contain(cell.repostItem))
                }
            }

            context("loves button") {

                it("usually enabled and visible") {
                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(cell.lovesControl.isEnabled).to(beTrue())
                    expect(toolBar.items).to(contain(cell.lovesItem))
                }

                it("shown if author allows it") {
                    let author: User = stub(["hasLovesEnabled": true])
                    let post: Post = stub([
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "author": author,
                        "lovesCount": 55
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(toolBar.items).to(contain(cell.lovesItem))
                }

                it("shown if author allows it in grid view") {
                    let author: User = stub(["hasLovesEnabled": true])
                    let post: Post = stub([
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "author": author,
                        "lovesCount": 55
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(toolBar.items).to(contain(cell.lovesItem))
                }

                it("hidden if author doesn't allow it") {
                    let author: User = stub(["hasLovesEnabled": false])
                    let post: Post = stub([
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "author": author,
                        "lovesCount": 55
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(toolBar.items).toNot(contain(cell.lovesItem))
                }

                it("hidden if author doesn't allow it in grid view") {
                    let author: User = stub(["hasLovesEnabled": false])
                    let post: Post = stub([
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "author": author,
                        "lovesCount": 55
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(toolBar.items).toNot(contain(cell.lovesItem))
                }

                it("enabled if author is current user") {
                    let author: User = stub(["hasLovesEnabled": true])
                    let post: Post = stub([
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "author": author,
                        "lovesCount": 55
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: author)

                    expect(cell.lovesControl.isEnabled) == true
                    expect(toolBar.items).to(contain(cell.lovesItem))
                }

                it("enabled if author is current user in grid view") {
                    let author: User = stub(["hasLovesEnabled": true])
                    let post: Post = stub([
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "author": author,
                        "lovesCount": 55
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: author)

                    expect(cell.lovesControl.isEnabled) == true
                    expect(toolBar.items).to(contain(cell.lovesItem))
                }

                it("hidden if author is current user, and loving isn't allowed") {
                    let author: User = stub(["hasLovesEnabled": false])
                    let post: Post = stub([
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "author": author,
                        "lovesCount": 55
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: author)

                    expect(toolBar.items).toNot(contain(cell.lovesItem))
                }

                it("hidden if author is current user, and loving isn't allowed in grid view") {
                    let author: User = stub(["hasLovesEnabled": false])
                    let post: Post = stub([
                        "viewsCount": 9,
                        "repostsCount": 4,
                        "commentsCount": 6,
                        "author": author,
                        "lovesCount": 55
                    ])
                    item = StreamCellItem(jsonable: post, type: .streamFooter)

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: author)

                    expect(toolBar.items).toNot(contain(cell.lovesItem))
                }
            }

            context("loading") {

                it("configures a stream footer cell") {
                    // set the state to loading
                    item.state = .loading

                    StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                    expect(cell.commentsOpened).to(beFalse())
                    expect(cell.views) == "9"
                    expect(cell.reposts) == "4"
                    expect(cell.comments) == "6"

                    // commentsButton should be selected when the state is loading
                    expect(cell.commentsControl.isSelected).to(beTrue())
                }
            }

            context("not loading") {

                context("expanded") {

                    it("configures a stream footer cell") {
                        // set the state to expanded
                        item.state = .expanded

                        StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                        expect(cell.commentsOpened).to(beTrue())
                        expect(cell.views) == "9"
                        expect(cell.reposts) == "4"
                        expect(cell.comments) == "6"

                        // commentsButton should be selected when expanded
                        expect(cell.commentsControl.isSelected).to(beTrue())
                    }

                }

                context("not expanded") {

                    it("configures a stream footer cell") {
                        // set the state to none
                        item.state = .none

                        StreamFooterCellPresenter.configure(cell, streamCellItem: item, streamKind: .following, indexPath: IndexPath(item: 0, section: 0), currentUser: nil)

                        expect(cell.commentsOpened).to(beFalse())
                        expect(item.state) == StreamCellState.collapsed
                        expect(cell.views) == "9"
                        expect(cell.reposts) == "4"
                        expect(cell.comments) == "6"
                        expect(cell.commentsControl.isSelected).to(beFalse())
                    }
                }
            }
        }
    }
}
