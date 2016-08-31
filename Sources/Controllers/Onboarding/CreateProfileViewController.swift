////
///  CreateProfileViewController.swift
//

public class CreateProfileViewController: UIViewController, HasAppController {
    var mockScreen: CreateProfileScreen?
    var screen: CreateProfileScreen { return mockScreen ?? (self.view as! CreateProfileScreen) }
    var parentAppController: AppViewController?
    var currentUser: User?
    public var onboardingViewController: OnboardingViewController?
    public var onboardingData: OnboardingData!

    override public func loadView() {
        let screen = CreateProfileScreen()
        screen.delegate = self
        self.view = screen
    }
}

extension CreateProfileViewController: CreateProfileDelegate {
    func presentController(controller: UIViewController) {
        presentViewController(controller, animated: true, completion: nil)
    }

    func dismissController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension CreateProfileViewController: OnboardingStepController {
    public func onboardingWillProceed(proceedClosure: () -> Void) {
    }

    public func onboardingStepBegin() {
    }
}
