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
        if let cell = cell as? StreamCreateCommentCell,
            comment = streamCellItem.jsonable as? ElloComment,
            post = comment.loadedFromPost,
            user = comment.author
        {
            let ownPost = currentUser?.id == post.authorId
            let replyAllVisibility: InteractionVisibility = ownPost ? .Enabled : .Hidden

            cell.avatarURL = user.avatarURL()
            cell.replyAllVisibility = replyAllVisibility
        }
    }

}
