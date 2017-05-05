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

            describe("+fromJSON(:)") {
                it("parses correctly") {
                    let data: [String: Any] = [
                        "id": "1",
                        "name": "Featured",
                        "slug": "featured",
                        "order": 0,
                        "uses_page_promotionals": true,
                        "level": "primary"
                    ]
                    let category = Category.fromJSON(data) as? Ello.Category
                    expect(category?.id) == "1"
                    expect(category?.name) == "Featured"
                    expect(category?.slug) == "featured"
                    expect(category?.usesPagePromo) == true
                    expect(category?.order) == 0
                    expect(category?.level) == .primary
                }
            }
        }
    }
}
