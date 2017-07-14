////
///  OnboardingCreatorTypeProtocols.swift
//

protocol OnboardingCreatorTypeDelegate: class {
    func creatorTypeChanged(type: Profile.CreatorType)
    func creatorSelectionChanged(count: Int)
}

protocol OnboardingCreatorTypeScreenProtocol: class {
    var delegate: OnboardingCreatorTypeDelegate? { get set }
    var creatorCategories: [String] { get set }
}
