////
///  ProfileCategoriesViewControllerSpec.swift
//

@testable import Ello
import Moya
import Quick
import Nimble


class ProfileCategoriesViewControllerSpec: QuickSpec {
    override func spec() {
        describe("ProfileCategoriesViewController") {
            var subject: ProfileCategoriesViewController!
            var navVC: ElloNavigationController!
            var profileVC: ProfileViewController!
            let art = Ello.Category.stub(["level": "primary", "slug": "art"])

            beforeEach {
                UIView.setAnimationsEnabled(false)
                profileVC = ProfileViewController(user: User.stub(["id": "42"]))
                navVC = ElloNavigationController(rootViewController: profileVC)

                showController(navVC)
                subject = ProfileCategoriesViewController(categories: [art])
                subject.presentingVC = profileVC
                subject.modalTransitionStyle = .crossDissolve
                subject.modalPresentationStyle = .custom
                subject.transitioningDelegate = subject
                profileVC.present(subject, animated: true, completion: nil)
            }

            afterEach {
                UIView.setAnimationsEnabled(true)
            }

            context("tapping a category") {

                // damn these async specs, they pass when focussed but always fail
                // when run wiht the suite
                xit("dismisses and pushes a CategoryViewController") {
                    subject.categoryTapped(art)
                    expect(navVC.viewControllers[0]).toEventually(beAKindOf(ProfileViewController.self))
                    expect(navVC.viewControllers.last).toEventually(beAKindOf(CategoryViewController.self))
                    expect(navVC.viewControllers.count).toEventually(equal(2))
                }
            }
        }
    }
}
