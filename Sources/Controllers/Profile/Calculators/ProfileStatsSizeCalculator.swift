////
///  ProfileStatsSizeCalculator.swift
//

import FutureKit


public struct ProfileStatsSizeCalculator {

    public func calculate(item: StreamCellItem) -> Future<CGFloat> {
        let promise = Promise<CGFloat>()
        promise.completeWithSuccess(70)
        return promise.future
    }
}

private extension ProfileStatsSizeCalculator {}
