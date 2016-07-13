////
///  UserListItemCellPresenter.swift
//

import Foundation

public struct UserListItemCellPresenter {

    public static func configure(
        cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: NSIndexPath,
        currentUser: User?)
    {
        if let cell = cell as? UserListItemCell,
            user = streamCellItem.jsonable as? User
        {
            cell.relationshipControl.hidden = false

            if let currentUser = currentUser {
                cell.relationshipControl.hidden = user.id == currentUser.id
            }

            cell.relationshipControl.showStarButton = streamKind.showStarButton
            cell.setUser(user)
        }
    }
}
