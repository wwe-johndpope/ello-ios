////
///  ProfileAvatarSizeCalculator.swift
//

import FutureKit


public class ProfileAvatarSizeCalculator: NSObject {

    public func calculate(item: StreamCellItem) -> Future<Int> {
        let promise = Promise<Int>()
        promise.completeWithSuccess(122)
        return promise.future
    }
}

private extension ProfileAvatarSizeCalculator {}
