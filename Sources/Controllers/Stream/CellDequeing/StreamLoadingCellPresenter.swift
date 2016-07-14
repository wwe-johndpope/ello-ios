////
///  StreamLoadingCellPresenter.swift
//

import Foundation

public struct StreamLoadingCellPresenter {

    static func configure(
        cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: NSIndexPath,
        currentUser: User?)
    {
        if let cell = cell as? StreamLoadingCell {
            cell.start()
        }
    }
}
