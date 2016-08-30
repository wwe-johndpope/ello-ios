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
        if let cell = cell as? TextHeaderCell,
            header = streamCellItem.type.data as? NSAttributedString
        {
            cell.header = header
        }
    }

}
