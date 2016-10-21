////
///  NilSafeEqualsSpec.swift
//

@testable import Ello
import Quick
import Nimble


class NilSafeEqualsSpec: QuickSpec {
    override func spec() {
        describe("NilSafeEquals") {
            let optA: String? = "a"
            let optA2: String? = "a"
            let optB: String? = "b"
            let optNil: String? = nil
            let optNil2: String? = nil
            let a = "a"
            let a2 = "a"
            let b = "b"
            it("works on optionals") {
                expect(optA =?= optA2) == true
                expect(optA =?= optNil) == false
                expect(optA =?= optB) == false
                expect(optNil =?= optNil2) == false
                expect(optA2 =?= optA) == true
                expect(optNil =?= optA) == false
                expect(optB =?= optA) == false
                expect(optNil2 =?= optNil) == false
            }
            it("works on one optional") {
                expect(a =?= optA2) == true
                expect(a =?= optNil) == false
                expect(a =?= optB) == false
                expect(optA2 =?= a) == true
                expect(optNil =?= a) == false
                expect(optB =?= a) == false
            }
            it("works on no optionals") {
                expect(a =?= a2) == true
                expect(a =?= b) == false
            }
        }
    }
}
