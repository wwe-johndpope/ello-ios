////
///  ElloProviderLinkExension.swift
//

import WebLinking


extension ElloProvider {
    func parseLinks(_ response: HTTPURLResponse?, config: ResponseConfig) -> ResponseConfig {
        if let nextLink = response?.findLink(relation: "next") {
            if let components = URLComponents(string: nextLink.uri) {
                config.nextQuery = components
            }
        }
        return config
    }
}
