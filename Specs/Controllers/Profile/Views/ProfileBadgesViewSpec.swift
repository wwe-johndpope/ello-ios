////
///  ProfileBadgesViewSpec.swift
//

@testable import Ello
import Quick
import Nimble


class ProfileBadgesViewSpec: QuickSpec {
    var featured: Badge! { return Badge.lookup(slug: "featured") }
    var community: Badge! { return Badge.lookup(slug: "community") }
    var experimental: Badge! { return Badge.lookup(slug: "experimental") }
    var staff: Badge! { return Badge.lookup(slug: "staff") }
    var spam: Badge! { return Badge.lookup(slug: "spam") }
    var nsfw: Badge! { return Badge.lookup(slug: "nsfw") }

    override func spec() {
        describe("ProfileBadgesView") {
            it("badges featured") {
                let subject = ProfileBadgesView(frame: CGRect(
                    origin: .zero,
                    size: CGSize(width: 187, height: 60)
                ))
                subject.badges = [self.featured]
                expectValidSnapshot(subject)
            }

            it("badges featured, community") {
                let subject = ProfileBadgesView(frame: CGRect(
                    origin: .zero,
                    size: CGSize(width: 187, height: 60)
                ))
                subject.badges = [self.featured, self.community]
                expectValidSnapshot(subject)
            }

            it("badges featured, community, experimental") {
                let subject = ProfileBadgesView(frame: CGRect(
                    origin: .zero,
                    size: CGSize(width: 187, height: 60)
                ))
                subject.badges = [self.featured, self.community, self.experimental]
                expectValidSnapshot(subject)
            }

            it("badges featured, community, experimental, staff") {
                let subject = ProfileBadgesView(frame: CGRect(
                    origin: .zero,
                    size: CGSize(width: 187, height: 60)
                ))
                subject.badges = [self.featured, self.community, self.experimental, self.staff]
                expectValidSnapshot(subject)
            }
        }
    }
}
