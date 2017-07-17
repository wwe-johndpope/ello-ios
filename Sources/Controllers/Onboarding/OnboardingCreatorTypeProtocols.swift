////
///  OnboardingCreatorTypeProtocols.swift
//

protocol OnboardingCreatorTypeDelegate: class {
    func creatorTypeChanged(type: OnboardingCreatorTypeScreen.CreatorType)
}

protocol OnboardingCreatorTypeScreenProtocol: class {
    var delegate: OnboardingCreatorTypeDelegate? { get set }
    var creatorCategories: [String] { get set }
}
