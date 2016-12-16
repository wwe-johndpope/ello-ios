////
///  StreamToggleCellPresenter.swift
//

import Foundation

public struct StreamToggleCellPresenter {

    static func configure(
        cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: NSIndexPath,
        currentUser: User?)
    {
        guard let
            cell = cell as? StreamToggleCell,
            post = streamCellItem.jsonable as? Post
        else { return }

        let message: String
        if streamCellItem.state == .Collapsed {
            message = InterfaceString.NSFW.Show
        }
        else {
            message = InterfaceString.NSFW.Hide
        }
        cell.label.text = "\(post.contentWarning) \(message)"
    }
}
