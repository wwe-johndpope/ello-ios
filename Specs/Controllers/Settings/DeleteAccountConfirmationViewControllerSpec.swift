////
///  DeleteAccountConfirmationViewControllerSpec.swift
//

@testable import Ello
import Quick
import Nimble


class DeleteAccountConfirmationViewControllerSpec: QuickSpec {
    override func spec() {
        describe("DeleteAccountConfirmationViewController") {
            var subject: DeleteAccountConfirmationViewController!

            beforeEach {
                subject = DeleteAccountConfirmationViewController()
                showController(subject)
            }

            it("IBOutlets are not nil") {
                expect(subject.titleLabel).notTo(beNil())
                expect(subject.infoLabel).notTo(beNil())
                expect(subject.buttonView).notTo(beNil())
                expect(subject.cancelView).notTo(beNil())
                expect(subject.cancelLabel).notTo(beNil())
            }
        }
    }
}
