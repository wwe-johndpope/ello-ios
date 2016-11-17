////
///  CategoryProtocols.swift
//

public protocol CategoryScreenProtocol: StreamableScreenProtocol {
    var topInsetView: UIView { get }
    var navBarsVisible: Bool? { get } // nil means "I don't know, check the UINavigationBar"
    func setCategoriesInfo(categoriesInfo: [CategoryCardListView.CategoryInfo], animated: Bool)
    func animateCategoriesList(navBarVisible navBarVisible: Bool)
    func scrollToCategoryIndex(index: Int)
}

public protocol CategoryScreenDelegate: class {
    func categorySelected(index: Int)
}
