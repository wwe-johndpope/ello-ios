////
///  ProfileBadgesSizeCalculator.swift
//

import PromiseKit


struct ProfileBadgesSizeCalculator {

    func calculate(_ item: StreamCellItem) -> Promise<CGFloat> {
        let (promise, resolve, _) = Promise<CGFloat>.pending()
        guard
            let user = item.jsonable as? User,
            user.badges.count > 0
        else {
            resolve(0)
            return promise
        }

        resolve(ProfileBadgesView.Size.height)
        return promise
    }
}
