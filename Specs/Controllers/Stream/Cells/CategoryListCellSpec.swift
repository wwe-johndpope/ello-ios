//
//  CategoryListCellSpec.swift
//  Ello
//
//  Created by Colin Gray on 6/16/2016.
//  Copyright (c) 2016 Ello. All rights reserved.
//

@testable import Ello
import Quick
import Nimble
import Nimble_Snapshots


class CategoryListCellSpec: QuickSpec {
    override func spec() {
        describe("CategoryListCell") {
            var subject: CategoryListCell!
            beforeEach {
                subject = CategoryListCell(frame: CGRect(origin: .zero, size: CGSize(width: 320, height: 66)))
                showView(subject)
            }

            it("displays categories") {
                subject.categoriesInfo = [
                    (title: "Featured", endpoint: .CategoryPosts(slug: "featured"), selected: false),
                    (title: "Art", endpoint: .CategoryPosts(slug: "art"), selected: false),
                ]
                subject.layoutIfNeeded()
                expect(subject).to(haveValidSnapshot())
            }

            it("hides categories that are off screen") {
                subject.categoriesInfo = [
                    (title: "Featured", endpoint: .CategoryPosts(slug: "featured"), selected: false),
                    (title: "MMMMMMMMM", endpoint: .CategoryPosts(slug: "mmmmmmmmm1"), selected: false),
                    (title: "MMMMMMMMM", endpoint: .CategoryPosts(slug: "mmmmmmmmm2"), selected: false),
                ]
                subject.layoutIfNeeded()
                expect(subject).to(haveValidSnapshot())
            }

            it("highlights the selected category") {
                subject.categoriesInfo = [
                    (title: "Featured", endpoint: .CategoryPosts(slug: "featured"), selected: true),
                    (title: "Art", endpoint: .CategoryPosts(slug: "art"), selected: false),
                ]
                subject.layoutIfNeeded()
                expect(subject).to(haveValidSnapshot())
            }

            it("highlights the selected category, after assigning duplicates") {
                subject.categoriesInfo = [
                    (title: "Featured", endpoint: .CategoryPosts(slug: "featured"), selected: true),
                    (title: "Art", endpoint: .CategoryPosts(slug: "art"), selected: false),
                ]
                subject.categoriesInfo = [
                    (title: "Featured", endpoint: .CategoryPosts(slug: "featured"), selected: false),
                    (title: "Art", endpoint: .CategoryPosts(slug: "art"), selected: true),
                ]
                subject.layoutIfNeeded()
                expect(subject).to(haveValidSnapshot())
            }
        }
    }
}
