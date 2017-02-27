////
///  RegionKindStreamCellTypeAdditionSpec.swift
//

@testable import Ello
import Quick
import Nimble


class RegionKindStreamCellTypeAdditionSpec: QuickSpec {
    override func spec() {
        describe("RegionKind.streamCellTypes") {
            it("should return images") {
                let kind = RegionKind.image
                let region = ImageRegion.stub([:])
                let streamCellTypes = kind.streamCellTypes(region)
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
                let kind = RegionKind.embed
                let region = EmbedRegion.stub([:])
                let streamCellTypes = kind.streamCellTypes(region)
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
                let kind = RegionKind.text
                let content = "<p>text</p>"
                let region = TextRegion.stub([
                    "content": content
                    ])
                let streamCellTypes = kind.streamCellTypes(region)
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
                let kind = RegionKind.text
                let content1 = "<p>text1</p>"
                let content2 = "<p>text2</p>"
                let region = TextRegion.stub([
                    "content": content1 + content2
                    ])
                let streamCellTypes = kind.streamCellTypes(region)
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

            it("should split break tags") {
                let kind = RegionKind.text
                let content1 = "text1"
                let content2 = "text2"
                let region = TextRegion.stub([
                    "content": "<p>\(content1)<br>\(content2)</p>"
                    ])
                let streamCellTypes = kind.streamCellTypes(region)
                expect(streamCellTypes.count) == 2
                if case let .text(data) = streamCellTypes[0], let textRegion = data as? TextRegion {
                    expect(textRegion.content) == "<p>\(content1)</p>"
                }
                else {
                    fail("wrong cell type \(streamCellTypes[0])")
                }

                if case let .text(data) = streamCellTypes[1], let textRegion = data as? TextRegion {
                    expect(textRegion.content) == "<p>\(content2)</p>"
                }
                else {
                    fail("wrong cell type \(streamCellTypes[1])")
                }
            }

            it("should truncate ridiculous text") {
                let kind = RegionKind.text
                let region = TextRegion.stub([
                    "content": "<p>" + String(repeating: "lorem", count: 8000/5) + "</p>"
                    ])
                let streamCellTypes = kind.streamCellTypes(region)
                expect(streamCellTypes.count) == 1
                if case let .text(data) = streamCellTypes[0], let textRegion = data as? TextRegion {
                    expect(textRegion.content).to(beginWith("<p>lorem"))
                    expect(textRegion.content).to(endWith("&hellip;</p>"))
                }
                else {
                    fail("wrong cell type \(streamCellTypes[0])")
                }
            }
        }
    }
}
