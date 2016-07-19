////
///  AssetsToRegionsSpec.swift
//

@testable import Ello
import Quick
import Nimble


class AssetsToRegionsSpec: QuickSpec {
    override func spec() {
        describe("AssetsToRegions") {
            it("should handle zero assets") {
                var ranSynchronously = false
                AssetsToRegions.processPHAssets([]) { imageData in
                    ranSynchronously = true
                    expect(imageData.count) == 0
                }
                expect(ranSynchronously) == true
            }
        }
    }
}
