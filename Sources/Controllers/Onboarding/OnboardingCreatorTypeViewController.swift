////
///  OnboardingCreatorTypeViewController.swift
//

class OnboardingCreatorTypeViewController: UIViewController, HasAppController, ControllerThatMightHaveTheCurrentUser {
    private var _mockScreen: OnboardingCreatorTypeScreenProtocol?
    var screen: OnboardingCreatorTypeScreenProtocol {
        set(screen) { _mockScreen = screen }
        get { return _mockScreen ?? (self.view as! OnboardingCreatorTypeScreen) }
    }

    var currentUser: User?
    var categories: [Category]?
    var creatorType: Profile.CreatorType = .none

    var appViewController: AppViewController? {
        return findViewController { vc in vc is AppViewController } as? AppViewController
    }

    var onboardingViewController: OnboardingViewController?
    var onboardingData: OnboardingData!

    override func loadView() {
        let screen = OnboardingCreatorTypeScreen()
        screen.delegate = self
        self.view = screen
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        CategoryService().loadCreatorCategories()
            .thenFinally { categories in
                self.categories = categories
                self.screen.creatorCategories = categories.map { $0.name }
            }
            .ignoreErrors()
    }
}

extension OnboardingCreatorTypeViewController: OnboardingCreatorTypeDelegate {

    func creatorTypeChanged(type: OnboardingCreatorTypeScreen.CreatorType) {
        switch type {
        case .none:
            creatorType = .none
        case .fan:
            creatorType = .fan
        case let .artist(selections):
            if let categories = categories {
                let selectedCategories = selections.map { categories[$0] }
                creatorType = .artist(selectedCategories)
            }
            else {
                creatorType = .none
            }
        }

        onboardingViewController?.canGoNext = creatorType.isValid
    }

}

extension OnboardingCreatorTypeViewController: OnboardingStepController {
    func onboardingStepBegin() {
        onboardingViewController?.hasAbortButton = false
        onboardingViewController?.canGoNext = false
        onboardingViewController?.prompt = InterfaceString.Onboard.CreateAccount
    }

    func onboardingWillProceed(abort: Bool, proceedClosure: @escaping (_ success: OnboardingViewController.OnboardingProceed) -> Void) {
        guard creatorType.isValid else { return }

        if case let .artist(selectedCategories) = creatorType {
            ProfileService().updateUserProfile([.creatorTypeCategoryIds: selectedCategories.map { $0.id }])
                .thenFinally { [weak self] _ in
                    guard let `self` = self else { return }

                    self.onboardingData.creatorType = self.creatorType
                    proceedClosure(.continue)
                }
                .catch { [weak self] _ in
                    guard let `self` = self else { return }

                    let alertController = AlertViewController(error: InterfaceString.GenericError)
                    self.appViewController?.present(alertController, animated: true, completion: nil)
                    proceedClosure(.error)
                }
        }
        else {
            proceedClosure(.continue)
        }
    }
}
