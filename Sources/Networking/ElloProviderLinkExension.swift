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
        if let prevLink = response?.findLink(relation: "prev") {
            if let components = URLComponents(string: prevLink.uri) {
                config.prevQuery = components
            }
        }
        if let firstLink = response?.findLink(relation: "first") {
            if let components = URLComponents(string: firstLink.uri) {
                config.firstQuery = components
            }
        }
        if let lastLink = response?.findLink(relation: "last") {
            if let components = URLComponents(string: lastLink.uri) {
                config.lastQuery = components
            }
        }
        return config
    }
}
