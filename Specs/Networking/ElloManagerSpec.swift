////
///  ElloManagerSpec.swift
//

import Ello
import Quick
import Moya
import Nimble
import Alamofire
import ElloCerts

class ElloManagerSpec: QuickSpec {
    override func spec() {

        describe("ElloManager") {
            afterEach {
                AppSetup.sharedState.isSimulator = true
            }

            describe("serverTrustPolicies") {

                if ElloCerts.isPublic {
                    it("has zero when running as open source app") {
                        AppSetup.sharedState.isSimulator = false
                        expect(ElloManager.serverTrustPolicies["ello.co"]).to(beNil())
                    }
                }
                else {
                    it("has one when not in the simulator") {
                        AppSetup.sharedState.isSimulator = false
                        expect(ElloManager.serverTrustPolicies["ello.co"]).notTo(beNil())
                    }
                }

                it("has zero when in the simulator") {
                    AppSetup.sharedState.isSimulator = true
                    expect(ElloManager.serverTrustPolicies["ello.co"]).to(beNil())
                }
            }

            describe("SSL Pinning") {

                it("has a custom Alamofire.Manager") {
                    let defaultManager = Alamofire.Manager.sharedInstance
                    let elloManager = ElloManager.manager

                    expect(elloManager).notTo(beIdenticalTo(defaultManager))
                }

                if !ElloCerts.isPublic {
                    it("includes 2 ssl certificates in the app") {
                        AppSetup.sharedState.isSimulator = false
                        let policy = ElloManager.serverTrustPolicies["ello.co"]!
                        var doesValidatesChain = false
                        var doesValidateHost = false
                        var keys = [SecKey]()
                        switch policy {
                        case let .PinPublicKeys(publicKeys, validateCertificateChain, validateHost):
                            doesValidatesChain = validateCertificateChain
                            doesValidateHost = validateHost
                            keys = publicKeys
                        default: break
                        }

                        expect(doesValidatesChain) == true
                        expect(doesValidateHost) == true
                        let numberOfCerts = 2
                        // Charles installs a cert, and we should allow that, so test
                        // for numberOfCerts OR numberOfCerts + 1
                        expect(keys.count == numberOfCerts || keys.count == numberOfCerts + 1) == true
                    }
                }
            }
        }
    }
}
