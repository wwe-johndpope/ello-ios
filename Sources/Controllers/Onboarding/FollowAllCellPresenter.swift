////
///  FollowAllCellPresenter.swift
//

public struct FollowAllCounts {
    let userCount: Int
    let followedCount: Int
}

public struct FollowAllCellPresenter {

    static func configure(
        cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: NSIndexPath,
        currentUser: User?)
    {
        if let cell = cell as? FollowAllCell,
            counts = streamCellItem.type.data as? FollowAllCounts
        {
            cell.userCount = counts.userCount
            cell.followedCount = counts.followedCount
        }
    }

}
