////
///  ContentFlaggingService.swift
//

import Moya
import SwiftyJSON

public typealias ContentFlaggingSuccessCompletion = () -> Void

public struct ContentFlaggingService {

    public init(){}

    public func flagContent(endpoint: ElloAPI, success: ContentFlaggingSuccessCompletion, failure: ElloFailureCompletion) {
        ElloProvider.shared.elloRequest(endpoint,
            success: { data in
                success()
        }, failure: failure)
    }
}
