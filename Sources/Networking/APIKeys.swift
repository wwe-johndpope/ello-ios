////
///  APIKeys.swift
//

import Foundation
import Keys

// Mark: - API Keys

struct APIKeys {
    let key: String
    let secret: String
    let segmentKey: String
    let httpProtocol: String
    let domain: String

    // MARK: Shared Keys

    static let `default`: APIKeys = {
        return APIKeys(
            key: ElloKeys().oauthKey(),
            secret: ElloKeys().oauthSecret(),
            segmentKey: ElloKeys().segmentKey(),
            httpProtocol: ElloKeys().httpProtocol(),
            domain: ElloKeys().domain()
            )
    }()
    static let staging: APIKeys = {
        return APIKeys(
            key: ElloKeys().stagingOauthKey(),
            secret: ElloKeys().stagingOauthSecret(),
            segmentKey: ElloKeys().stagingSegmentKey(),
            httpProtocol: ElloKeys().stagingHttpProtocol(),
            domain: ElloKeys().stagingDomain()
            )
    }()

    static var shared = APIKeys.default

    // MARK: Initializers

    init(key: String, secret: String, segmentKey: String, httpProtocol: String, domain: String) {
        self.key = key
        self.secret = secret
        self.segmentKey = segmentKey
        self.httpProtocol = httpProtocol
        self.domain = domain
    }
}
