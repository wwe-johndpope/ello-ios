////
///  StreamHeaderCellPresenter.swift
//

import TimeAgoInWords


struct StreamHeaderCellPresenter {

    static func configure(
        _ cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: IndexPath,
        currentUser: User?)
    {
        guard let cell = cell as? StreamHeaderCell,
            let authorable = streamCellItem.jsonable as? Authorable
        else { return}

        let post = streamCellItem.jsonable as? Post
        let isGridView = streamCellItem.isGridView(streamKind: streamKind)

        cell.close()
        cell.ownPost = false
        cell.ownComment = false
        cell.canDeleteComment = false
        cell.isGridLayout = isGridView

        switch streamKind {
        case .postDetail:
            cell.showUsername = false
        default:
            cell.showUsername = true
        }

        if let currentUser = currentUser,
            let comment = streamCellItem.jsonable as? ElloComment
        {
            if currentUser.isOwnerOf(comment: comment) {
                cell.ownComment = true
            }
            else if AuthToken().isStaff {
                cell.canDeleteComment = true
            }
            else if currentUser.isOwnerOfParentPost(comment: comment) {
                cell.ownPost = true
            }
        }

        var author = authorable.author
        var repostedBy: User? = nil
        var followButtonVisible = false
        if streamCellItem.type == .streamHeader {
            cell.avatarHeight = StreamHeaderCell.avatarHeight(isGridView: isGridView)
            cell.scrollView.isScrollEnabled = false
            cell.chevronHidden = true
            cell.goToPostView.isHidden = false

            if let repostAuthor = post?.repostAuthor {
                repostedBy = author
                author = repostAuthor
            }

            if let post = post, streamKind.isDetail(post: post) {
                followButtonVisible = true
            }
            cell.canReply = false
        }
        else {
            cell.showUsername = true
            cell.avatarHeight = 30.0
            cell.scrollView.isScrollEnabled = true
            cell.chevronHidden = false
            cell.goToPostView.isHidden = true
            cell.canReply = true
        }

        if author?.id == currentUser?.id {
            followButtonVisible = false
        }

        var category: Category?
        if streamKind.showsCategory {
            category = post?.category
        }

        cell.setDetails(user: author, repostedBy: repostedBy, category: category)
        cell.followButtonVisible = followButtonVisible
        if isGridView {
            cell.timeStamp = ""
        }
        else {
            cell.timeStamp = authorable.createdAt.timeAgoInWords()
        }
        cell.layoutIfNeeded()
    }
}
