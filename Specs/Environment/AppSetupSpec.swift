////
///  AppSetupSpec.swift
//

import Ello
import Quick
import Nimble


class AppSetupSpec: QuickSpec {
    override func spec() {
        describe("isSimulator: Bool") {
            it("should be true") {
                if UIDevice.currentDevice().name == "iPhone Simulator" {
                    expect(AppSetup.sharedState.isSimulator) == true
                }
                else if UIDevice.currentDevice().name == "iPad Simulator" {
                    expect(AppSetup.sharedState.isSimulator) == true
                }
                else {
                    expect(AppSetup.sharedState.isSimulator) == false
                }
            }
        }
    }
}
