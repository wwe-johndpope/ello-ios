////
///  ProfileNamesSizeCalculator.swift
//

import FutureKit


public class ProfileNamesSizeCalculator: NSObject {

    public func calculate(item: StreamCellItem) -> Future<CGFloat> {
        let promise = Promise<CGFloat>()
        promise.completeWithSuccess(122)
        return promise.future
    }
}

private extension ProfileNamesSizeCalculator {}
