////
///  TextHeaderCellPresenter.swift
//

public struct TextHeaderCellPresenter {

    static func configure(
        cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: NSIndexPath,
        currentUser: User?)
    {
        guard let
            cell = cell as? TextHeaderCell,
            header = streamCellItem.type.data as? NSAttributedString
        else { return}

        cell.header = header
    }

}
