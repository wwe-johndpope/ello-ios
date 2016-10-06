////
///  ProfileAvatarSizeCalculator.swift
//

import FutureKit


public class ProfileAvatarSizeCalculator: NSObject {

    public func calculate(item: StreamCellItem) -> Future<CGFloat> {
        let promise = Promise<CGFloat>()
        promise.completeWithSuccess(122)
        return promise.future
    }
}

private extension ProfileAvatarSizeCalculator {}
