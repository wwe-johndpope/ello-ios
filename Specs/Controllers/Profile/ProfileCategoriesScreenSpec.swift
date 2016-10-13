////
///  ProfileCategoriesScreenSpec.swift
//

@testable import Ello
import Quick
import Nimble


class ProfileCategoriesScreenSpec: QuickSpec {

    override func spec() {

        fdescribe("ProfileCategoriesScreen") {

            context("snapshots") {

                it("renders correctly with 1 category") {
                    let categories = [
                        Category(id: "123", name: "Photography", slug: "", order: 1, allowInOnboarding: false, level: .Primary, tileImage: nil)
                    ]

                    let subject = ProfileCategoriesScreen(categories: categories)
                    showView(subject)
                    expectValidSnapshot(subject, named: "ProfileCategoriesScreen_1", device: .Phone6_Portrait, record: true)
                }

                it("renders correctly with more2 categories") {
                    let categories = [
                        Category(id: "123", name: "Photography", slug: "", order: 1, allowInOnboarding: false, level: .Primary, tileImage: nil),
                        Category(id: "0123", name: "Art", slug: "", order: 2, allowInOnboarding: false, level: .Primary, tileImage: nil)
                    ]

                    let subject = ProfileCategoriesScreen(categories: categories)
                    showView(subject)
                    expectValidSnapshot(subject, named: "ProfileCategoriesScreen_2", device: .Phone6_Portrait, record: true)
                }

                it("renders correctly with 3 categories") {
                    let categories = [
                        Category(id: "123", name: "Photography", slug: "", order: 1, allowInOnboarding: false, level: .Primary, tileImage: nil),
                        Category(id: "0123", name: "Art", slug: "", order: 2, allowInOnboarding: false, level: .Primary, tileImage: nil),
                        Category(id: "0123s", name: "Painting", slug: "", order: 2, allowInOnboarding: false, level: .Primary, tileImage: nil)
                    ]

                    let subject = ProfileCategoriesScreen(categories: categories)
                    showView(subject)
                    expectValidSnapshot(subject, named: "ProfileCategoriesScreen_3", device: .Phone6_Portrait, record: true)
                }

                it("renders correctly with more than 3 categories") {
                    let categories = [
                        Category(id: "1", name: "Photography", slug: "", order: 1, allowInOnboarding: false, level: .Primary, tileImage: nil),
                        Category(id: "2", name: "Art", slug: "", order: 2, allowInOnboarding: false, level: .Primary, tileImage: nil),
                        Category(id: "3", name: "Painting", slug: "", order: 2, allowInOnboarding: false, level: .Primary, tileImage: nil),
                        Category(id: "4", name: "GIFs", slug: "", order: 2, allowInOnboarding: false, level: .Primary, tileImage: nil),
                        Category(id: "5", name: "Fashion", slug: "", order: 1, allowInOnboarding: false, level: .Primary, tileImage: nil),
                        Category(id: "6", name: "Climbing", slug: "", order: 2, allowInOnboarding: false, level: .Primary, tileImage: nil),
                        Category(id: "7", name: "Drawing", slug: "", order: 2, allowInOnboarding: false, level: .Primary, tileImage: nil),
                        Category(id: "8", name: "Sculpture", slug: "", order: 2, allowInOnboarding: false, level: .Primary, tileImage: nil)
                    ]

                    let subject = ProfileCategoriesScreen(categories: categories)
                    showView(subject)
                    expectValidSnapshot(subject, named: "ProfileCategoriesScreen_3_plus", device: .Phone6_Portrait, record: true)
                }
            }
        }
    }
}


