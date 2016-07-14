////
///  SeeAllCategoriesCellPresenter.swift
//

public struct SeeAllCategoriesCellPresenter {

    static func configure(
        cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: NSIndexPath,
        currentUser: User?)
    {
        if let cell = cell as? CategoryCell {
            cell.title = InterfaceString.SeeAll
            cell.highlight = .White
        }
    }

}
