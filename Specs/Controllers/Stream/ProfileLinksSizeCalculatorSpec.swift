////
///  ProfileLinksSizeCalculatorSpec.swift
//

@testable import Ello
import Quick
import Nimble


class ProfileLinksSizeCalculatorSpec: QuickSpec {
    override func spec() {
        describe("ProfileLinksSizeCalculator") {
            it("should return sensible size for links") {
                let user: User = stub([:])
                let calc = ProfileLinksSizeCalculator()
                var height: CGFloat?
                calc.calculate(StreamCellItem(jsonable: user, type: .Header))
                    .onSuccess { h in height = h }
                    .onFail { _ in }
                expect(height).toEventually(beGreaterThan(40))
            }
        }
    }
}
