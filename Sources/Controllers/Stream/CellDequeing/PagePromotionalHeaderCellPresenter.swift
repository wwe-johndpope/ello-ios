////
///  PagePromotionalHeaderCellPresenter.swift
//

struct PagePromotionalHeaderCellPresenter {

    static func configure(
        _ cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: IndexPath,
        currentUser: User?)
    {
        guard
            let cell = cell as? PromotionalHeaderCell,
            let pagePromotional = streamCellItem.jsonable as? PagePromotional
        else { return }

        let config = PromotionalHeaderCell.Config(pagePromotional: pagePromotional)
        cell.config = config
    }
}
