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
            pagePromotional = streamCellItem.jsonable as? PagePromotional
        else { return }

        var config = CategoryHeaderCell.Config(pagePromotional: pagePromotional)
        cell.config = config
    }
}
