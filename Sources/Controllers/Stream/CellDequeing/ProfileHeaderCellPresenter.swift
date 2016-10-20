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
        guard let
            cell = cell as? ProfileHeaderCell,
            user = streamCellItem.jsonable as? User
        else { return }

        cell.onHeightMismatch = { calculatedCellHeights in
            streamCellItem.calculatedCellHeights = calculatedCellHeights
            postNotification(StreamNotification.UpdateCellHeightNotification, value: cell)
        }
        cell.calculatedCellHeights = streamCellItem.calculatedCellHeights


        if streamCellItem.calculatedCellHeights.profileBio == 0 && streamCellItem.calculatedCellHeights.profileLinks == 0 {
            cell.statsView.grayLineVisible = false
        }

        if streamCellItem.calculatedCellHeights.profileLinks == 0 {
            cell.bioView.grayLineVisible = false
        }

        ProfileNamesPresenter.configure(cell.namesView, user: user, currentUser: currentUser)
        ProfileAvatarPresenter.configure(cell.avatarView, user: user, currentUser: currentUser)
        ProfileStatsPresenter.configure(cell.statsView, user: user, currentUser: currentUser)
        ProfileTotalCountPresenter.configure(cell.totalCountView, user: user, currentUser: currentUser)
        ProfileBioPresenter.configure(cell.bioView, user: user, currentUser: currentUser)
        ProfileLinksPresenter.configure(cell.linksView, user: user, currentUser: currentUser)
    }
}
