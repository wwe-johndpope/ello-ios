////
///  StreamCreateCommentCellPresenter.swift
//

public struct StreamCreateCommentCellPresenter {

    static func configure(
        cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: NSIndexPath,
        currentUser: User?)
    {
        guard let
            cell = cell as? StreamCreateCommentCell,
            comment = streamCellItem.jsonable as? ElloComment,
            post = comment.loadedFromPost,
            user = comment.author
        else {
            return
        }

        let ownPost = currentUser?.id == post.authorId
        let ownRepost = (post.isRepost && post.repostAuthor?.id =?= currentUser?.id)
        let replyAllVisibility: InteractionVisibility
        let watchVisibility: InteractionVisibility
        if ownPost {
            replyAllVisibility = .Enabled
            watchVisibility = .Hidden
        }
        else {
            replyAllVisibility = .Hidden
            if ownRepost {
                watchVisibility = .Hidden
            }
            else {
                watchVisibility = .Enabled
            }
        }

        cell.avatarURL = user.avatarURL()
        cell.replyAllVisibility = replyAllVisibility
        cell.watching = post.watching
        cell.watchVisibility = watchVisibility
    }

}
