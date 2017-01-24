////
///  AppSetupSpec.swift
//

@testable import Ello
import Quick
import Nimble


class AppSetupSpec: QuickSpec {
    override func spec() {
        describe("AppSetup") {

            describe("imageQuality") {
                afterEach() {
                    GroupDefaults["ElloImageUploadQuality"] = nil
                }

                it("sets group default") {
                    AppSetup.sharedState.imageQuality = 0.4

                    expect(GroupDefaults["ElloImageUploadQuality"].double) == 0.4
                }

                it("uses default") {
                    GroupDefaults["ElloImageUploadQuality"] = 0.5

                    expect(AppSetup.sharedState.imageQuality) == 0.5
                }

                it("defaults to 0.8") {
                    GroupDefaults["ElloImageUploadQuality"] = nil

                    expect(AppSetup.sharedState.imageQuality) == 0.8
                }
            }
        }
    }
}
