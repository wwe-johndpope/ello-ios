////
///  ElloRequest.swift
//

import Moya


struct ElloRequest {
    let url: URL
    let method: Moya.Method
    let parameters: [String: Any]?

    init(url: URL, method: Moya.Method = .get, parameters: [String: Any]? = nil) {
        self.url = url
        self.method = method
        self.parameters = parameters
    }
}
