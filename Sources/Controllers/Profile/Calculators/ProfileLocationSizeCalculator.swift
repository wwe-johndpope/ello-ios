////
///  ProfileLocationSizeCalculator.swift
//

import PromiseKit


struct ProfileLocationSizeCalculator {

    func calculate(_ item: StreamCellItem, maxWidth: CGFloat) -> Promise<CGFloat> {
        let (promise, resolve, _) = Promise<CGFloat>.pending()
        guard
            let user = item.jsonable as? User,
            let location = user.location, !location.isEmpty
        else {
            resolve(0)
            return promise
        }

        resolve(ProfileLocationView.Size.height)
        return promise
    }
}
