//
//  EmptyStreamCellPresenter.swift
//  Ello
//
//  Created by Sean on 11/22/16.
//  Copyright © 2016 Ello. All rights reserved.
//

////
///  EmptyStreamCellPresenter.swift
//

import Foundation

public struct StreEmptyStreamCellPresenter {

    public static func configure(
        cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: NSIndexPath,
        currentUser: User?)
    {
        guard 
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

