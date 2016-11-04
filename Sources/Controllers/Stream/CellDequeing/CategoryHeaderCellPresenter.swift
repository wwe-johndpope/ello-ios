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
        config.title = "Design" //category.name
        config.body = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam rutrum mauris vitae facilisis tincidunt. Ut a felis vel lorem tempor suscipit. In fringilla dictum lectus, et placerat sem ultricies id. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam rutrum mauris vitae facilisis tincidunt. Ut a felis vel lorem tempor suscipit. In fringilla dictum lectus, et placerat sem ultricies id." //category.body

        let promotional = category.randomPromotional
        config.imageURL = promotional?.image?.xhdpi?.url
        config.user = promotional?.user
        config.isSponsored = category.isSponsored
        config.callToAction = "normal CTA" // category.ctaCaption
        config.callToActionURL = NSURL(string: "http://www.boo.com") // category.ctaURL
        cell.config = config
    }
}
