////
///  RecordedResponse.swift
//

import Moya


public struct RecordedResponse {
    let endpoint: ElloAPI
    let responseClosure: (target: ElloAPI) -> EndpointSampleResponse

    public init(endpoint: ElloAPI, responseClosure: (target: ElloAPI) -> EndpointSampleResponse) {
        self.endpoint = endpoint
        self.responseClosure = responseClosure
    }

    public init(endpoint: ElloAPI, response: EndpointSampleResponse) {
        self.endpoint = endpoint
        self.responseClosure = { _ in return response }
    }

}
