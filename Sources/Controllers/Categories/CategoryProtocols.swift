////
///  CategoryProtocols.swift
//

public protocol CategoryScreenProtocol: StreamableScreenProtocol {
    var topInsetView: UIView { get }
    var navBarsVisible: Bool? { get }
    func setCategoriesInfo(categoriesInfo: [CategoryCardListView.CategoryInfo], animated: Bool)
    func animateCategoriesList(navBarVisible navBarVisible: Bool)
    func scrollToCategoryIndex(index: Int)
}

public protocol CategoryScreenDelegate: class {
}
