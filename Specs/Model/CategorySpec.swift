////
///  CategorySpec.swift
//

@testable import Ello
import Quick
import Nimble


class CategorySpec: QuickSpec {
    override func spec() {
        describe("Category") {
            describe("visibleOnSeeMore") {
                let expectations: [(level: CategoryLevel, visible: Bool)] = [
                    (level: .meta, visible: false),
                    (level: .primary, visible: true),
                    (level: .secondary, visible: true),
                    (level: .tertiary, visible: false),
                ]
                for (level, expected) in expectations {
                    it("\(level) \(expected ? "should" : "should not") be visible on see more") {
                        let category: Ello.Category = stub(["level": level.rawValue])
                        expect(category.visibleOnSeeMore) == expected
                    }
                }
            }
        }
    }
}
