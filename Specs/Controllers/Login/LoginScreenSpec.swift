////
///  LoginScreenSpec.swift
//

@testable import Ello
import Quick
import Nimble


class LoginScreenSpec: QuickSpec {
    override func spec() {
        describe("LoginScreen") {
            var subject: LoginScreen!
            beforeEach {
                subject = LoginScreen()
            }

            describe("snapshots") {
                validateAllSnapshots { return subject }
            }

            describe("snapshot, one password shown") {
                beforeEach {
                    subject.isOnePasswordAvailable = true
                }
                it("should have a valid snapshot") {
                    expectValidSnapshot(subject, device: .phone6_Portrait)
                }
            }

            describe("snapshot, error shown") {
                beforeEach {
                    subject.showError("error")
                }
                it("should have a valid snapshot") {
                    expectValidSnapshot(subject, device: .phone6_Portrait)
                }
            }

            describe("snapshot, keyboard shown") {
                beforeEach {
                    Keyboard.shared.isActive = true
                    Keyboard.shared.bottomInset = 216
                    subject.keyboardWillChange(Keyboard.shared, animated: false)
                }
                afterEach {
                    Keyboard.shared.isActive = false
                    Keyboard.shared.bottomInset = 0
                }
                it("should have a valid snapshot") {
                    expectValidSnapshot(subject, device: .phone6_Portrait)
                }
            }

            describe("text fields") {
                context("usernameField") {

                    it("is properly configured") {
                        expect(subject.usernameField.keyboardType) == UIKeyboardType.emailAddress
                        expect(subject.usernameField.returnKeyType) == UIReturnKeyType.next
                    }

                    it("has screen as delegate") {
                        expect(subject.usernameField.delegate) === subject
                    }

                }

                context("passwordField") {

                    it("is properly configured") {
                        expect(subject.passwordField.keyboardType) == UIKeyboardType.default
                        expect(subject.passwordField.returnKeyType) == UIReturnKeyType.go
                        expect(subject.passwordField.isSecureTextEntry) == true
                    }

                    it("has controller as delegate") {
                        expect(subject.passwordField.delegate) === subject
                    }
                }
            }
        }
    }
}
