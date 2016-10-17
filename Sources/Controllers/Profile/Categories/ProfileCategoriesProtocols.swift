////
///  ProfileCategoriesProtocols.swift
//

@objc
protocol ProfileCategoriesDelegate: class {
    func categoryTapped(category: Category)
    func dismiss()
}

protocol ProfileCategoriesProtocol: class {
    var background: UIView { get }
}
