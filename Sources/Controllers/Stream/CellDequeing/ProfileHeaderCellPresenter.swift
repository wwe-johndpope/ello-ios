////
///  ProfileHeaderCellPresenter.swift
//

import Foundation


public struct ProfileHeaderCellPresenter {

    public static func configure(
        cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: NSIndexPath,
        currentUser: User?)
    {
        guard let
            cell = cell as? ProfileHeaderCell,
            user = streamCellItem.jsonable as? User
        else { return }

        ProfileNamesPresenter.configure(cell.namesView, user: user, currentUser: currentUser)
        ProfileAvatarPresenter.configure(cell.avatarView, user: user, currentUser: currentUser)
    }
}
