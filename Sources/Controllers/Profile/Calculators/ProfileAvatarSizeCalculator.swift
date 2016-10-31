////
///  ProfileAvatarSizeCalculator.swift
//

import FutureKit


public struct ProfileAvatarSizeCalculator {

    public static func calculateHeight(maxWidth maxWidth: CGFloat) -> CGFloat {
        return ceil(maxWidth / ProfileHeaderCellSizeCalculator.ratio) + ProfileAvatarView.Size.whiteBarHeight
    }

    public func calculate(item: StreamCellItem, maxWidth: CGFloat) -> Future<CGFloat> {
        let promise = Promise<CGFloat>()
        promise.completeWithSuccess(ProfileAvatarSizeCalculator.calculateHeight(maxWidth: maxWidth))
        return promise.future
    }
}

private extension ProfileAvatarSizeCalculator {}
