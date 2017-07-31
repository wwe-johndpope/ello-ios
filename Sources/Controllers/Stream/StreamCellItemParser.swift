////
///  StreamCellItemParser.swift
//

struct StreamCellItemParser {

    init(){}

    func parse(_ items: [JSONAble], streamKind: StreamKind, forceGrid: Bool = false, currentUser: User? = nil) -> [StreamCellItem] {
        let viewsAdultContent = currentUser?.viewsAdultContent ?? false
        let filteredItems = streamKind.filter(items, viewsAdultContent: viewsAdultContent)
        var streamItems: [StreamCellItem] = []
        for item in filteredItems {
            if let post = item as? Post {
                streamItems += postCellItems(post, streamKind: streamKind, forceGrid: forceGrid)
            }
            else if let comment = item as? ElloComment {
                streamItems += commentCellItems(comment)
            }
            else if let notification = item as? Notification {
                streamItems += typicalCellItems(notification, type: .notification)
            }
            else if let announcement = item as? Announcement {
                streamItems += typicalCellItems(announcement, type: .announcement)
            }
            else if let user = item as? User {
                streamItems += typicalCellItems(user, type: .userListItem)
            }
            else if let editorial = item as? Editorial {
                streamItems += editorialCellItems(editorial)
            }
            else if let artistInvite = item as? ArtistInvite {
                if case .artistInvites = streamKind {
                    streamItems += typicalCellItems(artistInvite, type: .artistInviteBubble)
                }
                else if case .artistInviteDetail = streamKind {
                    streamItems += artistInviteDetailItems(artistInvite)
                }
            }
        }
        _ = streamItems.map { $0.forceGrid = forceGrid }
        return streamItems
    }

// MARK: - Private

    fileprivate func typicalCellItems(_ jsonable: JSONAble, type: StreamCellType) -> [StreamCellItem] {
        return [StreamCellItem(jsonable: jsonable, type: type)]
    }

    fileprivate func editorialCellItems(_ editorial: Editorial) -> [StreamCellItem] {
        return [StreamCellItem(jsonable: editorial, type: .editorial(editorial.kind))]
    }

    fileprivate func artistInviteDetailItems(_ artistInvite: ArtistInvite) -> [StreamCellItem] {
        return [
            StreamCellItem(jsonable: artistInvite, type: .artistInviteHeader, placeholderType: .artistInvites),
            // <-- the ↓submissions button goes here, so to separate these items we tag the placeholderType
            // the submissions button isn't inserted until the submission posts are loaded
            StreamCellItem(jsonable: artistInvite, type: .artistInviteControls, placeholderType: .artistInviteDetails),
        ] + artistInvite.guide.map({ StreamCellItem(jsonable: artistInvite, type: .artistInviteGuide($0), placeholderType: .artistInviteDetails) })
        + [StreamCellItem(jsonable: artistInvite, type: .spacer(height: 30), placeholderType: .artistInviteDetails)]
    }

    fileprivate func postCellItems(_ post: Post, streamKind: StreamKind, forceGrid: Bool) -> [StreamCellItem] {
        var cellItems: [StreamCellItem] = []
        let isGridView = streamKind.isGridView || forceGrid

        if !streamKind.isProfileStream || post.isRepost {
            cellItems.append(StreamCellItem(jsonable: post, type: .streamHeader))
        }
        else {
            cellItems.append(StreamCellItem(jsonable: post, type: .spacer(height: 30)))
        }
        cellItems += postToggleItems(post)
        if post.isRepost {
            // add repost content
            // this is weird, but the post summary is actually the repost summary on reposts
            if isGridView {
                cellItems += regionItems(post, content: post.summary)
            }
            else if let repostContent = post.repostContent {
                cellItems += regionItems(post, content: repostContent)
                // add additional content
                if let content = post.content {
                    cellItems += regionItems(post, content: content)
                }
            }
        }
        else {
            if let content = post.contentFor(gridView: isGridView) {
                cellItems += regionItems(post, content: content)
            }
        }
        cellItems += footerStreamCellItems(post)
        cellItems += [StreamCellItem(jsonable: post, type: .spacer(height: 10))]

        // set initial state on the items, but don't toggle the footer's state, it is used by comment open/closed
        for item in cellItems {
            if let post = item.jsonable as? Post, item.type != .streamFooter {
                item.state = post.isCollapsed ? .collapsed : .expanded
            }
        }

        return cellItems
    }

    fileprivate func commentCellItems(_ comment: ElloComment) -> [StreamCellItem] {
        var cellItems: [StreamCellItem] = [
            StreamCellItem(jsonable: comment, type: .commentHeader)
        ]
        cellItems += regionItems(comment, content: comment.content)
        return cellItems
    }

    fileprivate func postToggleItems(_ post: Post) -> [StreamCellItem] {
        if post.isCollapsed {
            return [StreamCellItem(jsonable: post, type: .toggle)]
        }
        else {
            return []
        }
    }

    fileprivate func regionItems(_ jsonable: JSONAble, content: [Regionable]) -> [StreamCellItem] {
        var cellArray: [StreamCellItem] = []
        for region in content {
            let kind = RegionKind(rawValue: region.kind) ?? .unknown
            let types = kind.streamCellTypes(region)
            for type in types where type != .unknown {
                let item: StreamCellItem = StreamCellItem(jsonable: jsonable, type: type)
                cellArray.append(item)
            }
        }
        return cellArray
    }

    fileprivate func footerStreamCellItems(_ post: Post) -> [StreamCellItem] {
        return [StreamCellItem(jsonable: post, type: .streamFooter)]
    }
}


// MARK: For Testing
extension StreamCellItemParser {
    func testingTypicalCellItems(_ jsonable: JSONAble, type: StreamCellType) -> [StreamCellItem] {
        return typicalCellItems(jsonable, type: type)
    }
    func testingPostCellItems(_ post: Post, streamKind: StreamKind, forceGrid: Bool) -> [StreamCellItem] {
        return postCellItems(post, streamKind: streamKind, forceGrid: forceGrid)
    }
    func testingCommentCellItems(_ comment: ElloComment) -> [StreamCellItem] {
        return commentCellItems(comment)
    }
}
