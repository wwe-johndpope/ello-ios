////
///  YourPresenter.swift
//

struct YourPresenter {

    static func configure(
        _ cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: IndexPath,
        currentUser: User?)
    {
        guard
            let cell = cell as? YourCell,
            let jsonable = streamCellItem.jsonable as? YourJsonable
        else { return }

        let config = YourCell.Config.from(jsonable: jsonable)
        cell.config = config
    }

}
