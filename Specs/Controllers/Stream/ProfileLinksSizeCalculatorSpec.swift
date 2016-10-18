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
                let links = [
                    ["url": "http://ello.co", "text": "ello.co"],
                ]
                let user: User = stub(["externalLinksList": links])
                let calc = ProfileLinksSizeCalculator()
                var height: CGFloat?
                calc.calculate(StreamCellItem(jsonable: user, type: .Header))
                    .onSuccess { h in height = h }
                    .onFail { _ in }
                expect(height) == 56
            }
            it("should return sensible size for many links and icons") {
                let links = [
                    ["url": "http://ello.co", "text": "ello.co"],
                    ["url": "http://ello.co", "text": "ello.co"],
                    ["url": "http://ello.co", "text": "ello.co", "icon": "http://social-icons.ello.co/ello.png"],
                ]
                let user: User = stub(["externalLinksList": links])
                let calc = ProfileLinksSizeCalculator()
                var height: CGFloat?
                calc.calculate(StreamCellItem(jsonable: user, type: .Header))
                    .onSuccess { h in height = h }
                    .onFail { _ in }
                expect(height) == 85
            }
            it("should return sensible size for lots of links and icons") {
                let links = [
                    ["url": "http://ello.co", "text": "ello.co"],
                    ["url": "http://ello.co", "text": "ello.co"],
                    ["url": "http://ello.co", "text": "ello.co"],
                    ["url": "http://ello.co", "text": "ello.co"],
                    ["url": "http://ello.co", "text": "ello.co"],
                    ["url": "http://ello.co", "text": "ello.co"],
                    ["url": "http://ello.co", "text": "ello.co", "icon": "http://social-icons.ello.co/ello.png"],
                    ]
                let user: User = stub(["externalLinksList": links])
                let calc = ProfileLinksSizeCalculator()
                var height: CGFloat?
                calc.calculate(StreamCellItem(jsonable: user, type: .Header))
                    .onSuccess { h in height = h }
                    .onFail { _ in }
                expect(height) == 201
            }
            it("should return sensible size for links and many icons") {
                let links = [
                    ["url": "http://ello.co", "text": "ello.co"],
                    ["url": "http://ello.co", "text": "ello.co", "icon": "http://social-icons.ello.co/ello.png"],
                    ["url": "http://ello.co", "text": "ello.co", "icon": "http://social-icons.ello.co/ello.png"],
                ]
                let user: User = stub(["externalLinksList": links])
                let calc = ProfileLinksSizeCalculator()
                var height: CGFloat?
                calc.calculate(StreamCellItem(jsonable: user, type: .Header))
                    .onSuccess { h in height = h }
                    .onFail { _ in }
                expect(height) == 56
            }
            it("should return sensible size for links and lots of icons") {
                let links = [
                    ["url": "http://ello.co", "text": "ello.co"],
                    ["url": "http://ello.co", "text": "ello.co", "icon": "http://social-icons.ello.co/ello.png"],
                    ["url": "http://ello.co", "text": "ello.co", "icon": "http://social-icons.ello.co/ello.png"],
                    ["url": "http://ello.co", "text": "ello.co", "icon": "http://social-icons.ello.co/ello.png"],
                    ["url": "http://ello.co", "text": "ello.co", "icon": "http://social-icons.ello.co/ello.png"],
                    ["url": "http://ello.co", "text": "ello.co", "icon": "http://social-icons.ello.co/ello.png"],
                    ["url": "http://ello.co", "text": "ello.co", "icon": "http://social-icons.ello.co/ello.png"],
                    ]
                let user: User = stub(["externalLinksList": links])
                let calc = ProfileLinksSizeCalculator()
                var height: CGFloat?
                calc.calculate(StreamCellItem(jsonable: user, type: .Header))
                    .onSuccess { h in height = h }
                    .onFail { _ in }
                expect(height) == 84
            }
            it("should return sensible size for icons") {
                let links = [
                    ["url": "http://ello.co", "text": "ello.co", "icon": "http://social-icons.ello.co/ello.png"],
                ]
                let user: User = stub(["externalLinksList": links])
                let calc = ProfileLinksSizeCalculator()
                var height: CGFloat?
                calc.calculate(StreamCellItem(jsonable: user, type: .Header))
                    .onSuccess { h in height = h }
                    .onFail { _ in }
                expect(height) == 52
            }
        }
    }
}
