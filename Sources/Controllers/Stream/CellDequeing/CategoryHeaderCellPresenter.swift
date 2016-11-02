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

        if let promotional = category.promotionals?.randomItem() {
            if let url = promotional.image?.large?.url {
                cell.setImageURL(url)
            }
        }
    }
}
