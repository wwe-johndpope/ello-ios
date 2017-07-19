////
///  OnboardingInterestsViewControllerSpec.swift
//

@testable import Ello
import Quick
import Nimble


class OnboardingInterestsViewControllerSpec: QuickSpec {
    override func spec() {
        var subject: OnboardingInterestsViewController!
        beforeEach {
            subject = OnboardingInterestsViewController()
            subject.onboardingData = OnboardingData()
        }
        describe("OnboardingInterestsViewController") {
            var categories: [Ello.Category]!
            beforeEach {
                let category: Ello.Category = stub(["name": "Art"])
                categories = [category]
                subject.categoriesSelectionChanged(selection: categories)
            }

            it("saves selected categories from streamViewController") {
                expect(subject.selectedCategories) == categories
            }
            it("submitting categories saves categories to onboardingData") {
                subject.onboardingWillProceed(abort: false, proceedClosure: { _ in })
                expect(subject.onboardingData.categories) == categories
            }
        }
    }
}
