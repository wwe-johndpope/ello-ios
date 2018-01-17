////
///  StreamImageViewerSpec.swift
//

@testable import Ello
import Quick
import Nimble
import Moya
import FLAnimatedImage

class StreamImageViewerSpec: QuickSpec {

    override func spec() {
        describe("StreamImageViewer") {
            var presentingVC: StreamViewController!
            var subject: StreamImageViewer!
            beforeEach {
                presentingVC = StreamViewController()
                subject = StreamImageViewer(presentingController: presentingVC)
            }

            describe("imageTapped(_:cell:)") {
                it("configures AppDelegate to allow rotation") {
                    subject.imageTapped(FLAnimatedImageView(), imageURL: URL(string: "http://www.example.com/image.jpg"))
                    expect(AppDelegate.restrictRotation) == false
                }
            }

            describe("imageViewerWillDismiss(_:)") {
                it("configures AppDelegate to prevent rotation") {
                    subject.imageViewerWillDismiss()
                    expect(AppDelegate.restrictRotation) == true
                }
            }
        }
    }
}
