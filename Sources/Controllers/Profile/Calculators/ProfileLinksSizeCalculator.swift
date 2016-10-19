////
///  ProfileLinksSizeCalculator.swift
//

import FutureKit


public struct ProfileLinksSizeCalculator {

    public func calculate(item: StreamCellItem) -> Future<CGFloat> {
        let promise = Promise<CGFloat>()
        guard let
            user = item.jsonable as? User,
            externalLinks = user.externalLinksList
        where externalLinks.count > 0
        else {
            promise.completeWithSuccess(0)
            return promise.future
        }

        let iconsCount = externalLinks.filter({ $0.iconURL != nil }).count
        let iconsRows = max(0, Int((iconsCount + 2) / 3))
        let iconsHeight = CGFloat(iconsRows) * ProfileLinksView.Size.iconSize.height + CGFloat(max(0, iconsRows - 1)) * ProfileLinksView.Size.iconMargins

        let linksCount = externalLinks.count - iconsCount
        let linksHeight = CGFloat(linksCount) * ProfileLinksView.Size.linkHeight + CGFloat(max(0, linksCount - 1)) * ProfileLinksView.Size.verticalLinkMargin
        promise.completeWithSuccess(ProfileLinksView.Size.margins.top + ProfileLinksView.Size.margins.bottom + max(iconsHeight, linksHeight))

        return promise.future
    }
}

private extension ProfileLinksSizeCalculator {}
