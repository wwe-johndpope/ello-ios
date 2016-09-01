////
///  OnboardingProtocols.swift
//

public enum OnboardingStep: Int {
    case Categories = 0
    case CreateProfile = 1
    case InviteFriends = 2

    public var nextStep: OnboardingStep? {
        switch self {
        case .Categories: return .CreateProfile
        case .CreateProfile: return .InviteFriends
        default: return nil
        }
    }
}

public protocol OnboardingDelegate: class {
    var canGoNext: Bool { get set }
    var prompt: String? { get set }

    func nextAction()
    func abortAction()
}

public protocol OnboardingScreenProtocol: class {
    var delegate: OnboardingDelegate? { get set }
    var controllerContainer: UIView { get set }
    var canGoNext: Bool { get set }
    var prompt: String? { get set }
    func styleFor(step step: OnboardingStep)
}

public protocol OnboardingStepController: class {
    var onboardingViewController: OnboardingViewController? { get set }
    var onboardingData: OnboardingData! { get set }
    func onboardingWillProceed(abort: Bool, proceedClosure: () -> Void)
    func onboardingStepBegin()
}
