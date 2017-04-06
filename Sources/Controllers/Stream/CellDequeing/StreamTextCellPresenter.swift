////
///  StreamTextCellPresenter.swift
//

struct StreamTextCellPresenter {

    static func configure(
        _ cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: IndexPath,
        currentUser: User?)
    {
        guard let cell = cell as? StreamTextCell else { return }

        cell.onWebContentReady { webView in
            if let actualHeight = webView.windowContentSize()?.height,
                let webContent = streamCellItem.calculatedCellHeights.webContent,
                ceil(actualHeight) != ceil(webContent)
            {
                streamCellItem.calculatedCellHeights.webContent = actualHeight
                streamCellItem.calculatedCellHeights.oneColumn = actualHeight
                streamCellItem.calculatedCellHeights.multiColumn = actualHeight
                postNotification(StreamNotification.UpdateCellHeightNotification, value: cell)
            }
        }

        var isRepost = false
        if let textRegion = streamCellItem.type.data as? TextRegion {
            isRepost = textRegion.isRepost
            let content = textRegion.content
            cell.html = content
        }

        // Repost specifics
        if isRepost {
            cell.margin = .repost
            cell.showBorder()
        }
        else if streamCellItem.jsonable is ElloComment {
            cell.margin = .comment
        }
        else {
            cell.margin = .post
        }
    }

}
