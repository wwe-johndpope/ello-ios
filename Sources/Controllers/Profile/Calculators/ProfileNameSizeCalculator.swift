////
///  ProfileNameSizeCalculator.swift
//

import FutureKit


public class ProfileNameSizeCalculator: NSObject {

    public func calculate(item: StreamCellItem) -> Future<CGFloat> {
        let promise = Promise<CGFloat>()
        promise.completeWithSuccess(122)
        return promise.future
    }
}

private extension ProfileNameSizeCalculator {}
