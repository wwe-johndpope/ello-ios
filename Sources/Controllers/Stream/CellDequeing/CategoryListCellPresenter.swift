////
///  CategoryListCellPresenter.swift
//

public struct CategoryListCellPresenter {

    static func configure(
        cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: NSIndexPath,
        currentUser: User?)
    {
        guard let
            cell = cell as? CategoryListCell,
            categoryList = streamCellItem.jsonable as? CategoryList
        else { return }

        cell.categoriesInfo = categoryList.categories.map { (title: $0.name, slug: $0.slug) }
    }

}
