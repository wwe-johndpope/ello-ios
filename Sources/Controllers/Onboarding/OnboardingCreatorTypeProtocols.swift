////
///  OnboardingCreatorTypeProtocols.swift
//

protocol OnboardingCreatorTypeDelegate: class {
}

protocol OnboardingCreatorTypeScreenProtocol: class {
    var delegate: OnboardingCreatorTypeDelegate? { get set }
    var creatorCategories: [String] { get set }
}
