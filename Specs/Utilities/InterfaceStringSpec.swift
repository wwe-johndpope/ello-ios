////
///  InterfaceStringSpec.swift
//

@testable import Ello
import Quick
import Nimble


class InterfaceStringSpec: QuickSpec {
    override func spec() {
        describe("InterfaceString") {
            describe("ArtistInvites") {
                let expectations: [(h: Int, m: Int, s: Int, String)] = [
                    (h: 40, m: 52, s: 31, "40:52:31 Remaining"),
                    (h: 10, m: 0, s: 0, "10:00:00 Remaining"),
                    (h: 0, m: 10, s: 0, "00:10:00 Remaining"),
                    (h: 0, m: 0, s: 10, "00:00:10 Remaining"),
                    (h: 2, m: 3, s: 1, "02:03:01 Remaining"),
                ]
                for (h, m, s, expected) in expectations {
                    let seconds = h * 3600 + m * 60 + s
                    it("formats Countdown(\(seconds))") {
                        expect(InterfaceString.ArtistInvites.Countdown(seconds)) == expected
                    }
                }
            }
        }
    }
}
