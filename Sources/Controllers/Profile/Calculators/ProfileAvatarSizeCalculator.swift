////
///  ProfileAvatarSizeCalculator.swift
//

import FutureKit


public struct ProfileAvatarSizeCalculator {

    public func calculate(item: StreamCellItem, maxWidth: CGFloat) -> Future<CGFloat> {
        let promise = Promise<CGFloat>()
        let headerHeight: CGFloat = maxWidth / ProfileHeaderCellSizeCalculator.ratio + ProfileAvatarView.Size.whiteBarHeight
        promise.completeWithSuccess(headerHeight)
        return promise.future
    }
}

private extension ProfileAvatarSizeCalculator {}
