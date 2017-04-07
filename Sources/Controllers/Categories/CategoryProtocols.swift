////
///  CategoryProtocols.swift
//

protocol CategoryScreenDelegate: class {
    func gridListToggled(sender: UIButton)
    func categorySelected(index: Int)
    func searchButtonTapped()
}

protocol CategoryScreenProtocol: StreamableScreenProtocol {
    var topInsetView: UIView { get }
    var categoryCardsVisible: Bool { get }
    var isGridView: Bool { get set }
    func set(categoriesInfo: [CategoryCardListView.CategoryInfo], animated: Bool, completion: @escaping ElloEmptyCompletion)
    func animateCategoriesList(navBarVisible: Bool)
    func scrollToCategory(index: Int)
    func selectCategory(index: Int)
}
