////
///  ProfileHeaderCellPresenter.swift
//

import Foundation


public struct ProfileHeaderCellPresenter {

    public static func configure(
        cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: NSIndexPath,
        currentUser: User?)
    {
        if let cell = cell as? ProfileHeaderCell {
            let ratio: CGFloat = 16.0/9.0

            cell.onWebContentReady { webView in
                let webViewHeight = webView.windowContentSize()?.height ?? 0
                let actualHeight = ProfileHeaderCellSizeCalculator.calculateHeightBasedOn(
                    webViewHeight: webViewHeight,
                    nameSize: cell.nameLabel.intrinsicContentSize(),
                    width: cell.frame.size.width
                    )
                if actualHeight != streamCellItem.calculatedOneColumnCellHeight {
                    cell.webViewHeight = webViewHeight

                    streamCellItem.calculatedWebHeight = webViewHeight
                    streamCellItem.calculatedOneColumnCellHeight = actualHeight
                    streamCellItem.calculatedMultiColumnCellHeight = actualHeight
                    postNotification(StreamNotification.UpdateCellHeightNotification, value: cell)
                }
            }

            cell.viewTopConstraint.constant = UIWindow.windowWidth() / ratio
            if let height = streamCellItem.calculatedWebHeight {
                cell.webViewHeight = height
            }

            cell.currentUser = currentUser

            if let user = streamCellItem.jsonable as? User {
                cell.user = user

                let isCurrentUser = (user.id == currentUser?.id)
                if let cachedImage = TemporaryCache.load(.Avatar)
                    where isCurrentUser
                {
                    cell.setAvatar(cachedImage)
                }
                else if let url = user.avatarURL(viewsAdultContent: currentUser?.viewsAdultContent, animated: true) {
                    cell.setAvatarURL(url)
                }

                cell.usernameLabel.text = user.atName
                cell.nameLabel.setLabelText(user.name, color: cell.nameLabel.textColor)
                cell.bioWebView.loadHTMLString(StreamTextCellHTML.postHTML(user.headerHTMLContent), baseURL: NSURL(string: "/"))

                let postCount = user.postsCount?.numberToHuman(showZero: true) ?? "0"
                cell.postsButton.count = postCount
                if let postCount = user.postsCount where postCount > 0 {
                    cell.postsButton.enabled = true
                }
                else {
                    cell.postsButton.enabled = false
                }

                let followingCount = user.followingCount?.numberToHuman(showZero: true) ?? "0"
                cell.followingButton.count = followingCount

                let lovesCount = user.lovesCount?.numberToHuman(showZero: true) ?? "0"
                cell.lovesButton.count = lovesCount

                // The user.followersCount is a String due to a special case where that can return ∞ for the ello user.
                // toInt() returns an optional that will fail when not an Int allowing the ∞ to display for the ello user.
                let fCount: String
                if let followerCount = user.followersCount, followerCountInt = Int(followerCount) {
                    fCount = followerCountInt.numberToHuman(showZero: true)
                }
                else {
                    fCount = user.followersCount ?? "0"
                }
                cell.followersButton.count = fCount
            }
            else {
                cell.bioWebView.loadHTMLString("", baseURL: nil)
                cell.showPlaceholders()
            }
        }
    }
}
