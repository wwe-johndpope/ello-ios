////
///  InterfaceStringSpec.swift
//

@testable import Ello
import Quick
import Nimble


class InterfaceStringSpec: QuickSpec {
    override func spec() {
        fdescribe("InterfaceString") {
            describe("ArtistInvites") {
                let expectations: [(h: Int, m: Int, s: Int, String)] = [
                    (h: 40, m: 52, s: 31, "40:52:31 Remaining"),
                    (h: 2, m: 3, s: 1, "02:03:01 Remaining"),
                ]
                for (h, m, s, expected) in expectations {
                    let seconds = h * 86400 + m * 60 + s
                    it("formats Countdown(\(seconds))") {
                        expect(InterfaceString.ArtistInvites.Countdown(seconds)) == expected
                    }
                }
            }
        }
    }
}
