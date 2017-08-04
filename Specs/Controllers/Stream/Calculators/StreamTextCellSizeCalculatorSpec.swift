////
///  StreamTextCellSizeCalculatorSpec.swift
//

@testable import Ello
import Quick
import Nimble


class StreamTextCellSizeCalculatorSpec: QuickSpec {
    override func spec() {
        var subject: StreamTextCellSizeCalculator!
        let mockHeight: CGFloat = 50
        beforeEach {
            let webView = MockUIWebView()
            webView.mockHeight = mockHeight
            subject = StreamTextCellSizeCalculator(webView: webView)
        }
        describe("StreamTextCellSizeCalculator") {
            it("assigns cell height to all cell items") {
                let post = Post.stub([:])

                let items = [
                    StreamCellItem(jsonable: post, type: .text(data: TextRegion(content: ""))),
                    StreamCellItem(jsonable: post, type: .text(data: TextRegion(content: ""))),
                    StreamCellItem(jsonable: post, type: .text(data: TextRegion(content: ""))),
                    StreamCellItem(jsonable: post, type: .text(data: TextRegion(content: ""))),
                ]
                var completed = false
                subject.processCells(items, withWidth: 100, columnCount: 1) {
                    completed = true
                }
                expect(completed) == true
                for item in items {
                    expect(item.calculatedCellHeights.oneColumn) == mockHeight
                }
            }
        }
    }
}
