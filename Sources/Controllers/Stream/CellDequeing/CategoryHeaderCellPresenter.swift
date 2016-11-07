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

        var config = CategoryHeaderCell.Config(category: category)
        cell.config = config
    }
}
