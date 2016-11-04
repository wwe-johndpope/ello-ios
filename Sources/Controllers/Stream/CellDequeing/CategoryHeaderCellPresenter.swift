////
///  CategoryHeaderCellPresenter.swift
//

public struct CategoryHeaderCellPresenter {

    static func configure(
        cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: NSIndexPath,
        currentUser: User?)
    {
        guard let
            cell = cell as? CategoryHeaderCell,
            category = streamCellItem.jsonable as? Category
        else { return }

        var config = CategoryHeaderCell.Config(style: .Category)
        config.title = category.name
        config.body = category.body

        let promotional = category.randomPromotional
        config.imageURL = promotional?.image?.xhdpi?.url
        config.user = promotional?.user
        config.isSponsored = category.isSponsored
        config.callToAction = category.ctaCaption
        config.callToActionURL = category.ctaURL
        cell.config = config
    }
}
