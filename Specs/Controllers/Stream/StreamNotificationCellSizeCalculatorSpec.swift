////
///  StreamNotificationCellSizeCalculatorSpec.swift
//

import Ello
import Quick
import Nimble


class StreamNotificationCellSizeCalculatorSpec : QuickSpec {
    class MockUIWebView: UIWebView {
        var mockHeight: CGFloat = 50

        override func loadHTMLString(html: String, baseURL: NSURL?) {
            delegate?.webViewDidFinishLoad?(self)
        }

        override func stringByEvaluatingJavaScriptFromString(js: String) -> String? {
            if js.contains("post-container") { return "\(frame.size.width)" }
            if js.contains("window.contentHeight") { return "\(mockHeight)" }
            return super.stringByEvaluatingJavaScriptFromString(js)
        }
    }

    override func spec() {
        describe("StreamNotificationCellSizeCalculator") {
            let user: User = stub([:])
            let text: TextRegion = stub(["content": "Lorem ipsum dolor sit amet."])
            let listItemText: TextRegion = stub(["content": "<ul><li>Lorem ipsum dolor sit amet.</li></ul>"])
            let image: ImageRegion = stub(["asset": Asset.stub(["attachment": Attachment.stub(["width": 2000, "height": 2000])])])
            let postWithText: Post = stub(["summary": [text], "content": [text], "author": user])
            let postWithListItem: Post = stub(["summary": [listItemText], "content": [listItemText], "author": user])
            let postWithImage: Post = stub(["summary": [image], "content": [image], "author": user])
            let postWithTextAndImage: Post = stub(["summary": [text, image], "content": [text, image], "author": user])
            let commentWithText: ElloComment = stub([
                "parentPost": postWithText,
                "content": text,
                "author": user,
                ])
            let commentWithListAndText: ElloComment = stub([
                "parentPost": postWithListItem,
                "content": text,
                "author": user,
                ])
            var subject: StreamNotificationCellSizeCalculator!
            beforeEach {
                subject = StreamNotificationCellSizeCalculator(webView: UIWebView(frame: CGRect(origin: .zero, size: CGSize(width: 320, height: 568))))
            }

            it("should return minimum size") {
                let activity: Activity = stub(["kind": "new_follower_post", "subject": user])
                let notification: Notification = stub(["activity": activity])
                let item = StreamCellItem(jsonable: notification, type: .Notification)
                waitUntil { done in
                    subject.processCells([item], withWidth: 320, columnCount: 1) {
                        done()
                    }
                }
                expect(item.calculatedWebHeight) == 0
                expect(item.calculatedOneColumnCellHeight) == 69
                expect(item.calculatedMultiColumnCellHeight) == 69
            }
            it("should return size that accounts for a message") {
                let activity: Activity = stub(["kind": "repost_notification", "subject": postWithText])
                let notification: Notification = stub(["activity": activity])
                let item = StreamCellItem(jsonable: notification, type: .Notification)
                waitUntil { done in
                    subject.processCells([item], withWidth: 320, columnCount: 1) {
                        done()
                    }
                }
                expect(item.calculatedWebHeight) == 39
                expect(item.calculatedOneColumnCellHeight) == 113
                expect(item.calculatedMultiColumnCellHeight) == 113
            }
            it("should return size that accounts for an image") {
                let activity: Activity = stub(["kind": "repost_notification", "subject": postWithImage])
                let notification: Notification = stub(["activity": activity])
                let item = StreamCellItem(jsonable: notification, type: .Notification)
                waitUntil { done in
                    subject.processCells([item], withWidth: 320, columnCount: 1) {
                        done()
                    }
                }
                expect(item.calculatedOneColumnCellHeight) == 117
                expect(item.calculatedMultiColumnCellHeight) == 117
            }
            it("should return size that accounts for an image with text") {
                let activity: Activity = stub(["kind": "repost_notification", "subject": postWithTextAndImage])
                let notification: Notification = stub(["activity": activity])
                let item = StreamCellItem(jsonable: notification, type: .Notification)
                waitUntil { done in
                    subject.processCells([item], withWidth: 320, columnCount: 1) {
                        done()
                    }
                }
                expect(item.calculatedWebHeight) == 63
                expect(item.calculatedOneColumnCellHeight) == 149
                expect(item.calculatedMultiColumnCellHeight) == 149
            }
            it("should return size that accounts for a reply button") {
                let activity: Activity = stub(["kind": "comment_notification", "subject": commentWithText])
                let notification: Notification = stub(["activity": activity])
                let item = StreamCellItem(jsonable: notification, type: .Notification)
                waitUntil { done in
                    subject.processCells([item], withWidth: 320, columnCount: 1) {
                        done()
                    }
                }
                expect(item.calculatedWebHeight) == 63
                expect(item.calculatedOneColumnCellHeight) == 189
                expect(item.calculatedMultiColumnCellHeight) == 189
            }
            it("should return size that accounts for a list item") {
                let activity: Activity = stub(["kind": "comment_notification", "subject": commentWithListAndText])
                let notification: Notification = stub(["activity": activity])
                let item = StreamCellItem(jsonable: notification, type: .Notification)
                waitUntil { done in
                    subject.processCells([item], withWidth: 320, columnCount: 1) {
                        done()
                    }
                }
                expect(item.calculatedWebHeight) == 114
                expect(item.calculatedOneColumnCellHeight) == 240
                expect(item.calculatedMultiColumnCellHeight) == 240
            }
        }
    }
}
