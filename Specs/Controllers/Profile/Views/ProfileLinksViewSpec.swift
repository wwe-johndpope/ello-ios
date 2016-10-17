////
///  ProfileLinksViewSpec.swift
//

@testable import Ello
import Quick
import Nimble


class ProfileLinksViewSpec: QuickSpec {
    override func spec() {
        describe("ProfileLinksView") {
            it("snapshots") {
                let subject = ProfileLinksView(frame: CGRect(
                    origin: .zero,
                    size: CGSize(width: 375, height: 60)
                    ))
                waitUntil { done in
                    delay(0.1) {
                        expectValidSnapshot(subject, named: "ProfileLinksView", device: .Custom(subject.frame.size))
                        done()
                    }
                }
            }
        }
    }
}
