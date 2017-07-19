////
///  ProfileAvatarSizeCalculator.swift
//

import PromiseKit


struct ProfileAvatarSizeCalculator {

    static func calculateHeight(maxWidth: CGFloat) -> CGFloat {
        return ceil(maxWidth / ProfileHeaderCellSizeCalculator.ratio) + ProfileAvatarView.Size.whiteBarHeight
    }

    func calculate(_ item: StreamCellItem, maxWidth: CGFloat) -> Promise<CGFloat> {
        let height = ProfileAvatarSizeCalculator.calculateHeight(maxWidth: maxWidth)
        return Promise<CGFloat>.resolve(height)
    }
}
