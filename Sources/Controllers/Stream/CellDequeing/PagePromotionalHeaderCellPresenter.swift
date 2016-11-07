////
///  PagePromotionalHeaderCellPresenter.swift
//

public struct PagePromotionalHeaderCellPresenter {

    static func configure(
        cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: NSIndexPath,
        currentUser: User?)
    {
        guard let
            cell = cell as? CategoryHeaderCell,
            promotional = streamCellItem.jsonable as? PagePromotional
        else { return }

        var config = CategoryHeaderCell.Config(style: .Page)
        config.title = promotional.header
        config.body = promotional.subheader
        config.imageURL = promotional.tileURL
        config.user = promotional.user
        config.callToAction = promotional.ctaCaption
        config.callToActionURL = promotional.ctaURL
        cell.config = config
    }
}
