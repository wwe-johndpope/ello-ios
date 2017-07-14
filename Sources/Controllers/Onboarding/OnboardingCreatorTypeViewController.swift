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
                self.screen.creatorCategories = categories.map { $0.name }
            }
            .ignoreErrors()
    }
}

extension OnboardingCreatorTypeViewController: OnboardingCreatorTypeDelegate {

    func creatorTypeChanged(type: Profile.CreatorType) {
    }

    func creatorSelectionChanged(count: Int) {
    }

    private func revalidate() {
    }

}

extension OnboardingCreatorTypeViewController: OnboardingStepController {
    func onboardingStepBegin() {
        onboardingViewController?.hasAbortButton = false
        onboardingViewController?.canGoNext = false
        onboardingViewController?.prompt = InterfaceString.Onboard.CreateAccount
    }

    func onboardingWillProceed(abort: Bool, proceedClosure: @escaping (_ success: OnboardingViewController.OnboardingProceed) -> Void) {
        guard !abort else {
            proceedClosure(.abort)
            return
        }

        proceedClosure(.continue)
    }
}
