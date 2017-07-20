////
///  OnboardingCreatorTypeProtocols.swift
//

protocol OnboardingCreatorTypeDelegate: class {
    func creatorTypeChanged(type: OnboardingCreatorTypeScreen.CreatorType)
}

protocol OnboardingCreatorTypeScreenProtocol: StreamableScreenProtocol {
    var delegate: OnboardingCreatorTypeDelegate? { get set }
    var creatorCategories: [String] { get set }
    var topInset: CGFloat { get set }
    var bottomInset: CGFloat { get set }

    func updateCreatorType(type: Profile.CreatorType)
}
