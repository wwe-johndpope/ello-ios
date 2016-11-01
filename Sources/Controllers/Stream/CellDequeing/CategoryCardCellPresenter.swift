////
///  CategoryCardCellPresenter.swift
//

public struct CategoryCardCellPresenter {

    static func configure(
        cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: NSIndexPath,
        currentUser: User?)
    {
        if let cell = cell as? CategoryCardCell,
            category = streamCellItem.jsonable as? Category
        {
            let desiredHeight: CGFloat = ceil(cell.frame.width / 1.5)
            if streamCellItem.calculatedCellHeights.oneColumn != desiredHeight || streamCellItem.calculatedCellHeights.multiColumn != desiredHeight {
                streamCellItem.calculatedCellHeights.oneColumn = desiredHeight
                streamCellItem.calculatedCellHeights.multiColumn = desiredHeight
                postNotification(StreamNotification.UpdateCellHeightNotification, value: cell)
            }

            cell.title = category.name
            cell.imageURL = category.tileURL
            cell.selectable = streamCellItem.type == .SelectableCategoryCard
        }
    }

}
