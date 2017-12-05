////
///  AutoCompleteViewControllerSpec.swift
//

@testable import Ello
import Quick
import Nimble


class AutoCompleteViewControllerSpec: QuickSpec {
    override func spec() {
        describe("AutoCompleteViewController") {
            describe("nib") {

                var subject: AutoCompleteViewController!

                beforeEach {
                    subject = AutoCompleteViewController()
                    showController(subject)
                }

                it("sets up the tableView's delegate and dataSource") {
                    expect(subject.tableView.delegate).to(equal(subject))
                    expect(subject.tableView.dataSource).to(beKindOf(AutoCompleteDataSource))
                }
            }

            describe("viewDidLoad()") {

                var subject: AutoCompleteViewController!

                beforeEach {
                    subject = AutoCompleteViewController()
                    showController(subject)
                }

                it("styles the view") {
                    expect(subject.tableView.backgroundColor) == UIColor.black
                }

                it("registers cells") {
                    let match = AutoCompleteMatch(type: AutoCompleteType.username, range: "test".startIndex..<"test".endIndex, text: "test")
                    subject.dataSource.items = [AutoCompleteItem(result: AutoCompleteResult(name: "test"), type: AutoCompleteType.emoji, match: match)]

                    expect(subject.tableView).to(haveRegisteredIdentifier(AutoCompleteCell.reuseIdentifier))
                }
            }
        }
    }
}
