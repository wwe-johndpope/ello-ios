////
///  ArtistInviteCellPresenter.swift
//

struct ArtistInviteCellPresenter {

    static func configure(
        _ cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: IndexPath,
        currentUser: User?)
    {
        guard
            let cell = cell as? ArtistInviteBubbleCell,
            let artistInvite = streamCellItem.jsonable as? ArtistInvite
        else { return }

        var config = ArtistInviteBubbleCell.Config()
        config.title = artistInvite.title
        config.description = artistInvite.shortDescription
        config.inviteType = artistInvite.inviteType
        config.status = artistInvite.status
        config.openedAt = artistInvite.openedAt
        config.closedAt = artistInvite.closedAt
        cell.config = config
    }

}
