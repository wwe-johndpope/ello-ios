////
///  ProfileTotalCountSizeCalculator.swift
//

import FutureKit


public struct ProfileTotalCountSizeCalculator {

    public func calculate(item: StreamCellItem) -> Future<CGFloat> {
        let promise = Promise<CGFloat>()
        promise.completeWithSuccess(60)
        return promise.future
    }
}

private extension ProfileTotalCountSizeCalculator {}
