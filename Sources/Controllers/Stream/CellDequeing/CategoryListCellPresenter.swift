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
        if let cell = cell as? CategoryListCell,
            categoryList = streamCellItem.jsonable as? CategoryList
        {
            cell.categoriesInfo = categoryList.categories.map { (title: $0.name, slug: $0.slug) }
        }
    }

}
