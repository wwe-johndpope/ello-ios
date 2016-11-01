////
///  AvatarButtonSpec.swift
//

@testable import Ello
import Quick
import Nimble


class AvatarButtonSpec: QuickSpec {
    override func spec() {
        describe("AvatarButton") {
            context("assigning user") {
                var subject: AvatarButton!
                var user: User!
                let url = NSURL(string: "http://www.example.com/image")!

                beforeEach {
                    subject = AvatarButton()
                    user = User.empty()
                }

                it("should assign the asset url via User") {
                    let asset = Asset(url: url)
                    user.avatar = asset
                    subject.setUser(user)
                    expect(subject.imageURL) == url
                }

                it("should assign the asset url") {
                    subject.setUserAvatarURL(url)
                    expect(subject.imageURL) == url
                }

                it("should assign the asset large url") {
                    let asset = Asset(id: NSUUID().UUIDString)
                    let attachment = Attachment(url: url)
                    asset.large = attachment
                    user.avatar = asset
                    subject.setUser(user)
                    expect(subject.imageURL) == url
                }

                it("should assign the asset optimized url") {
                    let asset = Asset(id: NSUUID().UUIDString)
                    let attachment = Attachment(url: url)
                    asset.optimized = attachment
                    user.avatar = asset
                    subject.setUser(user)
                    expect(subject.imageURL) == url
                }

            }
        }
    }
}
