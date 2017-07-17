////
///  OnboardingCreatorTypeProtocols.swift
//

protocol OnboardingCreatorTypeDelegate: class {
    func creatorTypeChanged(type: OnboardingCreatorType)
}

protocol OnboardingCreatorTypeScreenProtocol: class {
    var delegate: OnboardingCreatorTypeDelegate? { get set }
    var creatorCategories: [String] { get set }
}

enum OnboardingCreatorType {
    case none
    case fan
    case artist(Int)
}
