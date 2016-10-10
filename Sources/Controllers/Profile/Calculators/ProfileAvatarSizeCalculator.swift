////
///  ProfileAvatarSizeCalculator.swift
//

import FutureKit


public struct ProfileAvatarSizeCalculator {

    public func calculate(item: StreamCellItem) -> Future<CGFloat> {
        let promise = Promise<CGFloat>()
        promise.completeWithSuccess(255)
        return promise.future
    }
}

private extension ProfileAvatarSizeCalculator {}
