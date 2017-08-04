////
///  StreamCellItemParserSpec.swift
//

@testable import Ello
import Quick
import Nimble
import Moya


class StreamCellItemParserSpec: QuickSpec {
    override func spec() {
        describe("StreamCellItemParser") {

            var subject: StreamCellItemParser!
            beforeEach {
                subject = StreamCellItemParser()
            }

            describe("-streamCellItems:") {

                it("returns an empty array if an empty array of Posts is passed in") {
                    let posts = [Post]()
                    expect(subject.parse(posts, streamKind: .following).count) == 0
                }

                it("returns an empty array if an empty array of Comments is passed in") {
                    let comments = [ElloComment]()
                    expect(subject.parse(comments, streamKind: .following).count) == 0
                }

                it("returns an array with the proper count of stream cell items when parsing friends.json's posts") {
                    var cellItems = [StreamCellItem]()
                    StreamService().loadStream(endpoint: .following)
                        .thenFinally { response in
                            if case let .jsonables(jsonables, _) = response {
                                cellItems = subject.parse(jsonables, streamKind: .following)
                            }
                        }
                        .catch { _ in }
                    expect(cellItems.count) == 8
                }

                it("doesn't include user's own post headers on a profile stream") {
                    var cellItems = [StreamCellItem]()
                    StreamService().loadStream(endpoint: .following)
                        .thenFinally { response in
                            if case let .jsonables(jsonables, _) = response {
                                cellItems = subject.parse(jsonables, streamKind: .userStream(userParam: "42"))
                            }
                        }
                        .catch { _ in }
                    let header = cellItems.find { $0.type == .streamHeader }
                    expect(header).to(beNil())
                }

                it("returns an empty array if an empty array of Activities is passed in") {
                    let activities: [Ello.Notification] = []
                    expect(subject.parse(activities, streamKind: .notifications(category: nil)).count) == 0
                }

                it("returns an array with the proper count of stream cell items when parsing friends.json's activities") {
                    var loadedNotifications = [StreamCellItem]()
                    StreamService().loadStream(endpoint: .notificationsStream(category: nil))
                        .thenFinally { response in
                            if case let .jsonables(jsonables, _) = response {
                                loadedNotifications = subject.parse(jsonables, streamKind: .notifications(category: nil))
                            }
                        }
                        .catch { _ in }
                    expect(loadedNotifications.count) == 14
                }
            }

            describe("regionStreamCells") {
                it("should return images") {
                    let region = ImageRegion.stub([:])
                    let streamCellTypes = subject.regionStreamCells(region)
                    expect(streamCellTypes.count) == 1
                    if let streamCellType = streamCellTypes.first {
                        if case .image(_) = streamCellType {
                            expect(true) == true
                        }
                        else {
                            fail("wrong cell type \(streamCellType)")
                        }
                    }
                }

                it("should return embeds") {
                    let region = EmbedRegion.stub([:])
                    let streamCellTypes = subject.regionStreamCells(region)
                    expect(streamCellTypes.count) == 1
                    if let streamCellType = streamCellTypes.first {
                        if case .embed(_) = streamCellType {
                            expect(true) == true
                        }
                        else {
                            fail("wrong cell type \(streamCellType)")
                        }
                    }
                }

                it("should return simple text") {
                    let content = "<p>text</p>"
                    let region = TextRegion.stub([
                        "content": content
                        ])
                    let streamCellTypes = subject.regionStreamCells(region)
                    expect(streamCellTypes.count) == 1
                    if let streamCellType = streamCellTypes.first {
                        if case let .text(data) = streamCellType, let textRegion = data as? TextRegion {
                            expect(textRegion.content) == content
                        }
                        else {
                            fail("wrong cell type \(streamCellType)")
                        }
                    }
                }

                it("should split paragraphs") {
                    let content1 = "<p>text1</p>"
                    let content2 = "<p>text2</p>"
                    let region = TextRegion.stub([
                        "content": content1 + content2
                        ])
                    let streamCellTypes = subject.regionStreamCells(region)
                    expect(streamCellTypes.count) == 2
                    if case let .text(data) = streamCellTypes[0], let textRegion = data as? TextRegion {
                        expect(textRegion.content) == content1
                    }
                    else {
                        fail("wrong cell type \(streamCellTypes[0])")
                    }

                    if case let .text(data) = streamCellTypes[1], let textRegion = data as? TextRegion {
                        expect(textRegion.content) == content2
                    }
                    else {
                        fail("wrong cell type \(streamCellTypes[1])")
                    }
                }

                it("should not split break tags") {
                    let content1 = "text1"
                    let content2 = "text2"
                    let region = TextRegion.stub([
                        "content": "<p>\(content1)<br>\(content2)</p>"
                        ])
                    let streamCellTypes = subject.regionStreamCells(region)
                    expect(streamCellTypes.count) == 1
                    if case let .text(data) = streamCellTypes[0], let textRegion = data as? TextRegion {
                        expect(textRegion.content) == region.content
                    }
                    else {
                        fail("wrong cell type \(streamCellTypes[0])")
                    }
                }

                it("should truncate ridiculous text") {
                    let region = TextRegion.stub([
                        "content": "<p>" + String(repeating: "a", count: 8000) + "</p>"
                        ])
                    let streamCellTypes = subject.regionStreamCells(region)
                    expect(streamCellTypes.count) == 1
                    if case let .text(data) = streamCellTypes[0], let textRegion = data as? TextRegion {
                        expect(textRegion.content).to(beginWith("<p>aaaaa"))
                        expect(textRegion.content).to(endWith("&hellip;</p>"))
                    }
                    else {
                        fail("wrong cell type \(streamCellTypes[0])")
                    }
                }
            }
        }
    }
}
