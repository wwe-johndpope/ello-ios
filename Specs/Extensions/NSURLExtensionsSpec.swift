////
///  NSURLSpec.swift
//

import Ello
import Quick
import Nimble

class NSURLExtensionSpec: QuickSpec {
    override func spec() {
        describe("hasGifExtension") {
            let expectations: [(String, Bool)] = [
                ("http://ello.co/file.gif", true),
                ("http://ello.co/file.GIF", true),
                ("http://ello.co/file.Gif", true),
                ("http://ello.co/filegif", false),
                ("http://ello.co/file/gif", false),
            ]
            for (url, expected) in expectations {
                it("should be \(expected) for \(url)") {
                    expect(NSURL(string: url)?.hasGifExtension) == expected
                }
            }
        }

        describe("isValidShorthand") {
            let expectations: [(String, Bool)] = [
                ("http://ello.co", true),
                ("https://ello.co/destination", true),
                ("ello.co", true),
                ("ello.co/destination", true),
                ("bla", false),
                ("bla/bla/bla", false),
            ]
            for (url, expected) in expectations {
                it("\(url) should\(expected ? "" : " not") be valid") {
                    expect(NSURL.isValidShorthand(url)) == expected
                }
            }
        }

        describe("absoluteStringWithoutProtocol") {
            it("returns the path of the url without the protocol") {
                let expectedPath = "stream/foo/bar"
                let path = "ello://" + expectedPath
                let url = NSURL(string: path)

                expect(url?.absoluteStringWithoutProtocol).to(equal(expectedPath))
            }
        }
    }
}
