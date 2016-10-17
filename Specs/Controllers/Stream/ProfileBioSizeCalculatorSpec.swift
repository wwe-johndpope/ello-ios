////
///  ProfileBioSizeCalculatorSpec.swift
//

@testable import Ello
import Quick
import Nimble


class ProfileBioSizeCalculatorSpec: QuickSpec {
    override func spec() {
        describe("ProfileBioSizeCalculator") {
            xit("should return sensible size for a bio") {
                let user: User = stub([
                    "formattedShortBio": "<p>bio</p>",
                ])
                let calc = ProfileBioSizeCalculator()
                var height: CGFloat?
                calc.calculate(StreamCellItem(jsonable: user, type: .Header), maxWidth: 320)
                    .onSuccess { h in height = h }
                    .onFail { _ in }
                expect(height).toEventually(beGreaterThan(40))
            }
        }
    }
}
