////
///  ResponseConfigSpec.swift
//

@testable import Ello
import Quick
import Nimble


class ResponseConfigSpec: QuickSpec {
    override func spec() {
        describe("isOutOfData") {
            let nextComponents = URLComponents(string: "https://ello.co?next=next")!
            let emptyComponents = URLComponents()

            context("when the number of remaining pages is 0") {
                it("returns true") {
                    let config = ResponseConfig()
                    config.totalPagesRemaining = "0"
                    config.nextQuery = nextComponents

                    expect(config.isOutOfData()).to(beTrue())
                }
            }

            context("when the number of remaining pages is nil") {
                it("returns true") {
                    let config = ResponseConfig()
                    config.totalPagesRemaining = .none
                    config.nextQuery = nextComponents

                    expect(config.isOutOfData()).to(beTrue())
                }
            }

            context("when the next query items are empty") {
                it("returns true") {
                    let config = ResponseConfig()
                    config.totalPagesRemaining = "1"
                    config.nextQuery = emptyComponents

                    expect(config.isOutOfData()).to(beTrue())
                }
            }

            context("when the next query items are nil") {
                it("returns true") {
                    let config = ResponseConfig()
                    config.totalPagesRemaining = "1"
                    config.nextQuery = .none

                    expect(config.isOutOfData()).to(beTrue())
                }
            }

            context("when the configuration has query items as well as remaining pages") {
                it("returns false") {
                    let config = ResponseConfig()
                    config.totalPagesRemaining = "1"
                    config.nextQuery = nextComponents

                    expect(config.isOutOfData()).to(beFalse())
                }
            }
        }
    }
}
