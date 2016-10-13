////
///  ProfileCategoriesViewController.swift
//

public final class ProfileCategoriesViewController: BaseElloViewController {

    var categories = [Category]()
    public init(categories: [Category]) {
        super.init(nibName: nil, bundle: nil)
        self.categories = categories
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var mockScreen: ProfileCategoriesProtocol?
    var screen: ProfileCategoriesProtocol { return mockScreen ?? (self.view as! ProfileCategoriesProtocol) }

    override public func loadView() {
        let screen = ProfileCategoriesScreen(categories: categories)
        screen.delegate = self
        self.view = screen
    }

}

extension ProfileCategoriesViewController: ProfileCategoriesDelegate {

    public func categoryTapped(category: Category) {
        print("Tapped \(category.endpoint)")
    }

}
