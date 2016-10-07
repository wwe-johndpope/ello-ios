////
///  ProfileLinksSizeCalculator.swift
//

import FutureKit


public struct ProfileLinksSizeCalculator {

    public func calculate(item: StreamCellItem) -> Future<CGFloat> {
        let promise = Promise<CGFloat>()
        promise.completeWithSuccess(122)
        return promise.future
    }
}

private extension ProfileLinksSizeCalculator {}
