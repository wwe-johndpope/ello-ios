////
///  AutoCompleteCellPresenterSpec.swift
//

@testable import Ello
import Quick
import Nimble

class AutoCompleteCellPresenterSpec: QuickSpec {
    override func spec() {
        describe("AutoCompleteCellPresenter") {
            context("username") {
                it("configures a AutoCompleteCell") {
                    let match = AutoCompleteMatch(type: AutoCompleteType.username, range: ("test".startIndex..<"test".endIndex), text: "test")
                    let result = AutoCompleteResult(name: "Billy", url: "http://www.example.com/avatar")
                    let item = AutoCompleteItem(result: result, type: AutoCompleteType.username, match: match)

                    let cell: AutoCompleteCell = AutoCompleteCell.loadFromNib()

                    AutoCompleteCellPresenter.configure(cell, item: item)
                    expectValidSnapshot(cell)
                }
            }

            context("emoji") {
                it("configures a AutoCompleteCell") {
                    let match = AutoCompleteMatch(type: AutoCompleteType.emoji, range: ("test".startIndex..<"test".endIndex), text: "test")
                    let result = AutoCompleteResult(name: "thumbsup", url: "http://www.example.com/emoji")
                    let item = AutoCompleteItem(result: result, type: AutoCompleteType.emoji, match: match)

                    let cell: AutoCompleteCell = AutoCompleteCell.loadFromNib()

                    AutoCompleteCellPresenter.configure(cell, item: item)
                    expectValidSnapshot(cell)
                }
            }
        }
    }
}
