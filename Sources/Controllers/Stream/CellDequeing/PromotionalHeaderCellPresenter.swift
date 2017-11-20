////
///  PromotionalHeaderCellPresenter.swift
//

struct PromotionalHeaderCellPresenter {

    static func configure(
        _ cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: IndexPath,
        currentUser: User?)
    {
        guard
            let cell = cell as? PromotionalHeaderCell,
            let category = streamCellItem.jsonable as? Category
        else { return }

        let config = PromotionalHeaderCell.Config(category: category)
        cell.config = config
    }
}
