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
            let announcement = streamCellItem.jsonable as? ArtistInvite
        else { return }
    }

}
