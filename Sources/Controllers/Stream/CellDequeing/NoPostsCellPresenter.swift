////
///  NoPostsCellPresenter.swift
//

public struct NoPostsCellPresenter {

    static func configure(
        cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: NSIndexPath,
        currentUser: User?)
    {
        guard let
            cell = cell as? NoPostsCell,
            user = streamCellItem.jsonable as? User
        else { return }

        cell.isCurrentUser = currentUser?.id == user.id
    }
}
