////
///  StreamEmbedCellPresenter.swift
//

import Foundation

public struct StreamEmbedCellPresenter {

    public static func configure(
        cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: NSIndexPath,
        currentUser: User?)
    {
        if let cell = cell as? StreamEmbedCell,
            embedData = streamCellItem.type.data as? EmbedRegion
        {
            var photoToLoad: NSURL?
            if streamKind.isGridView {
                photoToLoad = embedData.thumbnailSmallUrl
            }
            else {
                photoToLoad = embedData.thumbnailLargeUrl
            }
            cell.embedUrl = embedData.url
            if embedData.isAudioEmbed {
                cell.setPlayImageIcon(.AudioPlay)
            }
            else {
                cell.setPlayImageIcon(.VideoPlay)
            }

            if let photoURL = photoToLoad {
                cell.setImageURL(photoURL)
            }

            // Repost specifics
            if embedData.isRepost {
                cell.leadingConstraint.constant = 30.0
                cell.showBorder()
            }
            else {
                cell.leadingConstraint.constant = 0.0
            }
        }
    }
}
