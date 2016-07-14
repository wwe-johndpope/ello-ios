////
///  ColumnToggleCellPresenter.swift
//

public struct ColumnToggleCellPresenter {

    static func configure(
        cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: NSIndexPath,
        currentUser: User?)
    {
        if let cell = cell as? ColumnToggleCell {
            cell.isGridView = streamKind.isGridView
        }
    }
}
