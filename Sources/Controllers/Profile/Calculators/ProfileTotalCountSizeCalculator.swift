////
///  ProfileTotalCountSizeCalculator.swift
//

import FutureKit


public class ProfileTotalCountSizeCalculator: NSObject {

    public func calculate(item: StreamCellItem) -> Future<CGFloat> {
        let promise = Promise<CGFloat>()
        promise.completeWithSuccess(122)
        return promise.future
    }
}

private extension ProfileTotalCountSizeCalculator {}
