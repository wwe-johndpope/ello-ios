////
///  SpecsTrackingAgent.swift
//

@testable import Ello

class SpecsTrackingAgent: AnalyticsAgent {

    var resetCalled = false
    var lastEvent = ""
    var lastUserId: String? = ""
    var lastTraits: [String: Any]?
    var lastScreenTitle = ""
    var lastProperties: [String: Any]?

    func identify(_ userId: String?, traits: [String: Any]?) {
        lastUserId = userId
        lastTraits = traits
    }

    func track(_ event: String) {
        lastEvent = event
    }

    func track(_ event: String, properties: [String: Any]?) {
        lastEvent = event
        lastProperties = properties
    }

    func screen(_ screenTitle: String) {
        lastScreenTitle = screenTitle
    }

    func screen(_ screenTitle: String, properties: [String: Any]?) {
        lastScreenTitle = screenTitle
        lastProperties = properties
    }

    func reset() {
        resetCalled = true
    }
}
