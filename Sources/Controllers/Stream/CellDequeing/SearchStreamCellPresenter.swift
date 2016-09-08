////
///  SearchStreamCellPresenter.swift
//

public struct SearchStreamCellPresenter {

    static func configure(
        cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: NSIndexPath,
        currentUser: User?)
    {
        guard let
            cell = cell as? SearchStreamCell,
            search = streamCellItem.jsonable as? SearchString,
            case let .Search(placeholder) = streamCellItem.type
        else { return }

        cell.placeholder = placeholder
        cell.search = search.text
    }
}
