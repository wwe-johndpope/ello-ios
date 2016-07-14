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
            let searchFor: String?
            if case let .CategoryPosts(category) = streamKind {
                searchFor = category
            }
            else if case let .Discover(type) = streamKind {
                searchFor = type.slug
            }
            else {
                searchFor = nil
            }

            cell.categoriesInfo = categoryList.categories.map { (title: $0.name, endpoint: $0.endpoint, selected: $0.slug == searchFor) }
        }
    }

}
