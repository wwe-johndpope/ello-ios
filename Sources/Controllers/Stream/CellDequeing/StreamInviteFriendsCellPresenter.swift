////
///  StreamInviteFriendsCellPresenter.swift
//

import Foundation

public struct StreamInviteFriendsCellPresenter {

    public static func configure(
        cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: NSIndexPath,
        currentUser: User?)
    {
        if let cell = cell as? StreamInviteFriendsCell,
            person = streamCellItem.jsonable as? LocalPerson
        {
            cell.person = person
        }
    }
}
