////
///  EmptyStreamCellPresenter.swift
//

import Foundation

public struct EmptyStreamCellPresenter {

    public static func configure(
        cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: NSIndexPath,
        currentUser: User?)
    {
        guard let cell = cell as? EmptyStreamCell else { return }

        cell.title = InterfaceString.EmptyStreamText
    }
}

