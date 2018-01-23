////
///  ElloManager.swift
//

import Alamofire
import ElloCerts


struct ElloManager {
    static var serverTrustPolicies: [String: ServerTrustPolicy] {
        let policyDict: [String: ServerTrustPolicy]
        if Globals.isSimulator {
            // make Charles plays nice in the sim by not setting a policy
            policyDict = [:]
        }
        else if Globals.isTesting {
            // allow testing of policy certs
            policyDict = ElloCerts.policy
        }
        else {
#if DEBUG
            // avoid policy certs on any debug build
            policyDict = [:]
#else
            policyDict = ElloCerts.policy
#endif
        }
        return policyDict
    }

    static var manager: SessionManager {
        let config = URLSessionConfiguration.default
        config.sharedContainerIdentifier = ElloGroupName
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30
        return SessionManager(
            configuration: config,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: ElloManager.serverTrustPolicies)
        )
    }

    static var shareExtensionManager: SessionManager {
        let config = URLSessionConfiguration.background(withIdentifier: "co.ello.shareextension.background")
        config.sharedContainerIdentifier = ElloGroupName
        config.sessionSendsLaunchEvents = false
        return SessionManager(
            configuration: config,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: ElloManager.serverTrustPolicies)
        )
    }

}
