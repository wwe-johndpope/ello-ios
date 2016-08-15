////
///  StreamImageCellPresenter.swift
//

import Foundation

public struct StreamImageCellPresenter {

    static func preventImageStretching(cell: StreamImageCell, attachmentWidth: Int, columnWidth: CGFloat, leftMargin: CGFloat) {
        let width = CGFloat(attachmentWidth)
        if width < columnWidth - leftMargin {
            cell.imageRightConstraint.constant = columnWidth - width - leftMargin
        }
        else {
            cell.imageRightConstraint.constant = 0
        }
    }

    static func calculateStreamImageMargin(
        cell: StreamImageCell,
        imageRegion: ImageRegion,
        streamCellItem: StreamCellItem) -> StreamImageCell.StreamImageMargin
    {
        // Repost specifics
        if imageRegion.isRepost == true {
            return .Repost
        }
        else if streamCellItem.jsonable is ElloComment {
            return .Comment
        }
        else {
            return .Post
        }
    }

    public static func configure(
        cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: NSIndexPath,
        currentUser: User?)
    {
        guard let
            cell = cell as? StreamImageCell,
            imageRegion = streamCellItem.type.data as? ImageRegion
        else {
            return
        }

        var attachmentToLoad: Attachment?
        var imageToLoad: NSURL?
        var showGifInThisCell = false
        if let asset = imageRegion.asset where asset.isGif {
            if streamKind.supportsLargeImages || !asset.isLargeGif {
                attachmentToLoad = asset.optimized
                imageToLoad = asset.optimized?.url
                showGifInThisCell = true
            }
            else {
                cell.presentedImageUrl = asset.optimized?.url
                cell.isLargeImage = true
            }
            cell.isGif = true
        }

        cell.isGridView = streamKind.isGridView
        if streamKind.isGridView {
            attachmentToLoad = attachmentToLoad ?? imageRegion.asset?.gridLayoutAttachment
        }
        else {
            attachmentToLoad = attachmentToLoad ?? imageRegion.asset?.oneColumnAttachment
        }

        let imageToShow = attachmentToLoad?.image
        imageToLoad = imageToLoad ?? attachmentToLoad?.url

        let cellMargin = calculateStreamImageMargin(cell, imageRegion: imageRegion, streamCellItem: streamCellItem)
        cell.marginType = cellMargin

        if let attachmentWidth = attachmentToLoad?.width {
            let columnWidth: CGFloat = calculateColumnWidth(screenWidth: UIWindow.windowWidth(), columnCount: streamKind.columnCountFor(width: cell.frame.width))
            preventImageStretching(cell, attachmentWidth: attachmentWidth, columnWidth: columnWidth, leftMargin: cell.margin)
        }

        cell.onHeightMismatch = { actualHeight in
            streamCellItem.calculatedWebHeight = actualHeight
            streamCellItem.calculatedOneColumnCellHeight = actualHeight
            streamCellItem.calculatedMultiColumnCellHeight = actualHeight
            postNotification(StreamNotification.UpdateCellHeightNotification, value: cell)
        }

        if let image = imageToShow where !showGifInThisCell {
            cell.setImage(image)
        }
        else if let imageURL = imageToLoad {
            cell.serverProvidedAspectRatio = StreamImageCellSizeCalculator.aspectRatioForImageRegion(imageRegion)
            cell.setImageURL(imageURL)
        }
        else if let imageURL = imageRegion.url {
            cell.isGif = imageURL.hasGifExtension
            cell.setImageURL(imageURL)
        }

        cell.buyButtonURL = imageRegion.buyButtonURL
        cell.layoutIfNeeded()
    }
}
