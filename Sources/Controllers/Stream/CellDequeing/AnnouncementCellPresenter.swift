////
///  AnnouncementCellPresenter.swift
//

public struct AnnouncementCellPresenter {

    static func configure(
        cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: NSIndexPath,
        currentUser: User?)
    {
        guard let
            cell = cell as? AnnouncementCell,
            announcement = streamCellItem.jsonable as? Announcement
        else { return }

        var config = AnnouncementCell.Config()
        config.title = announcement.header
        config.body = announcement.body
        config.callToAction = announcement.ctaCaption
        config.imageURL = announcement.imageURL
        cell.config = config
    }
}
