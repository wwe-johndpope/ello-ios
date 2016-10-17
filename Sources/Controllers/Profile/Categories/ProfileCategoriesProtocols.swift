////
///  ProfileCategoriesProtocols.swift
//

protocol ProfileCategoriesDelegate: class {
    func categoryTapped(category: Category)
}

protocol ProfileCategoriesProtocol: class {
    var background: UIView { get }
}
