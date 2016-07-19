////
///  StreamHeaderCellSpec.swift
//

@testable import Ello
import Quick
import Nimble
import Nimble_Snapshots


class StreamHeaderCellSpec: QuickSpec {
    enum Owner {
        case Me
        case Other
    }
    enum Content {
        case Post
        case Repost
        case Comment
    }
    enum Style {
        case Grid
        case Wide
        case Detail
    }
    override func spec() {
        describe("StreamHeaderCell") {
            describe("snapshots") {
                let me: User = stub(["username": "me"])
                let other: User = stub(["username": "other"])
                let reposter: User = stub(["username": "reposter"])
                let category: Ello.Category = stub(["name": "Illustrations"])
                let expectations: [
                    (String, owner: Owner, content: Content, category: Bool, follow: Bool, style: Style)
                ] = [
                    ("own post", owner: .Me, content: .Post, category: false, follow: false, style: .Wide),
                    ("own post in detail", owner: .Me, content: .Post, category: false, follow: false, style: .Detail),
                    ("own post in grid", owner: .Me, content: .Post, category: false, follow: false, style: .Grid),
                    ("own post w category", owner: .Me, content: .Post, category: true, follow: false, style: .Wide),
                    ("own post w category in detail", owner: .Me, content: .Post, category: true, follow: false, style: .Detail),
                    ("own post w category in grid", owner: .Me, content: .Post, category: true, follow: false, style: .Grid),
                    ("own repost", owner: .Me, content: .Repost, category: false, follow: false, style: .Wide),
                    ("own repost in detail", owner: .Me, content: .Repost, category: false, follow: false, style: .Detail),
                    ("own repost in grid", owner: .Me, content: .Repost, category: false, follow: false, style: .Grid),
                    ("own repost w category", owner: .Me, content: .Repost, category: true, follow: false, style: .Wide),
                    ("own repost w category in detail", owner: .Me, content: .Repost, category: true, follow: false, style: .Detail),
                    ("own repost w category in grid", owner: .Me, content: .Repost, category: true, follow: false, style: .Grid),
                    ("own comment", owner: .Me, content: .Comment, category: false, follow: false, style: .Wide),
                    ("own comment in detail", owner: .Me, content: .Comment, category: false, follow: false, style: .Detail),
                    ("own comment in grid", owner: .Me, content: .Comment, category: false, follow: false, style: .Grid),
                    ("other post", owner: .Other, content: .Post, category: false, follow: false, style: .Wide),
                    ("other post in detail", owner: .Other, content: .Post, category: false, follow: false, style: .Detail),
                    ("other post in grid", owner: .Other, content: .Post, category: false, follow: false, style: .Grid),
                    ("other post w follow in detail", owner: .Other, content: .Post, category: false, follow: true, style: .Detail),
                    ("other post w category", owner: .Other, content: .Post, category: true, follow: false, style: .Wide),
                    ("other post w category in detail", owner: .Other, content: .Post, category: true, follow: false, style: .Detail),
                    ("other post w category in grid", owner: .Other, content: .Post, category: true, follow: false, style: .Grid),
                    ("other repost", owner: .Other, content: .Repost, category: false, follow: false, style: .Wide),
                    ("other repost in detail", owner: .Other, content: .Repost, category: false, follow: false, style: .Detail),
                    ("other repost in grid", owner: .Other, content: .Repost, category: false, follow: false, style: .Grid),
                    ("other repost w follow in detail", owner: .Other, content: .Repost, category: false, follow: true, style: .Detail),
                    ("other repost w category", owner: .Other, content: .Repost, category: true, follow: false, style: .Wide),
                    ("other repost w category in detail", owner: .Other, content: .Repost, category: true, follow: false, style: .Detail),
                    ("other repost w category in grid", owner: .Other, content: .Repost, category: true, follow: false, style: .Grid),
                    ("other comment", owner: .Other, content: .Comment, category: false, follow: false, style: .Wide),
                    ("other comment in detail", owner: .Other, content: .Comment, category: false, follow: false, style: .Detail),
                    ("other comment in grid", owner: .Other, content: .Comment, category: false, follow: false, style: .Grid),
                ]
                let detailFrame = CGRect(x: 0, y: 0, width: 320, height: 90)
                let commentFrame = CGRect(x: 0, y: 0, width: 320, height: 60)
                let gridFrame = CGRect(x: 0, y: 0, width: 154, height: 60)
                for (desc, owner, content, hasCategory, hasFollow, style) in expectations {
                    it("has valid screenshot for \(desc)") {
                        let inGrid: Bool
                        let inDetail: Bool
                        switch style {
                            case .Grid:
                                inGrid = true
                                inDetail = false
                            case .Detail:
                                inGrid = false
                                inDetail = true
                            case .Wide:
                                inGrid = false
                                inDetail = false
                        }

                        let subject = StreamHeaderCell.loadFromNib() as StreamHeaderCell
                        if inGrid {
                            subject.frame = gridFrame
                        }
                        else if content == .Comment {
                            subject.frame = commentFrame
                        }
                        else {
                            subject.frame = detailFrame
                        }
                        subject.indexPath = NSIndexPath(forItem: 0, inSection: 0)
                        subject.ownPost = false
                        subject.ownComment = false
                        subject.isGridLayout = inGrid
                        subject.followButtonVisible = hasFollow

                        if content == .Comment {
                            subject.showUsername = true
                            subject.avatarHeight = 30.0
                            subject.chevronHidden = false
                            subject.goToPostView.hidden = true
                            subject.canReply = true
                        }
                        else {
                            subject.showUsername = !inDetail
                            subject.avatarHeight = inGrid ? 30 : 60
                            subject.chevronHidden = true
                            subject.goToPostView.hidden = false
                            subject.canReply = false
                        }

                        let user: User?
                        let repostedBy: User?
                        let cellCategory: Ello.Category?

                        if owner == .Me {
                            user = me
                            switch content {
                            case .Post:
                                subject.ownPost = true
                            case .Repost:
                                subject.ownPost = true
                            case .Comment:
                                subject.ownComment = true
                            }
                        }
                        else {
                            user = other
                        }

                        if content == .Comment {
                            subject.showUsername = true
                            subject.avatarHeight = 30.0
                            subject.chevronHidden = false
                            subject.goToPostView.hidden = true
                            subject.canReply = true
                        }
                        else {
                            subject.showUsername = !inDetail
                            subject.avatarHeight = inGrid ? 30 : 60
                            subject.chevronHidden = true
                            subject.goToPostView.hidden = false
                            subject.canReply = false
                        }

                        if content == .Repost {
                            repostedBy = reposter
                        }
                        else {
                            repostedBy = nil
                        }

                        if hasCategory {
                            cellCategory = category
                        }
                        else {
                            cellCategory = nil
                        }

                        subject.timeStamp = "1m"
                        subject.setDetails(user: user, repostedBy: repostedBy, category: cellCategory)
                        subject.avatarButton.setImage(UIImage(named: "specs-avatar", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil), forState: .Normal)

                        subject.layoutIfNeeded()
                        showView(subject)
                        expect(subject).to(haveValidSnapshot())
                    }
                }
            }
        }
    }
}
