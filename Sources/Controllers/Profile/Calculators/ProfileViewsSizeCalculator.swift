////
///  ProfileViewsSizeCalculator.swift
//

import FutureKit


public class ProfileViewsSizeCalculator: NSObject {

    public func calculate(item: StreamCellItem) -> Future<Int> {
        let promise = Promise<Int>()
        promise.completeWithSuccess(122)
        return promise.future
    }
}

private extension ProfileViewsSizeCalculator {}
