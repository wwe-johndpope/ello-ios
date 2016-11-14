////
///  ProfileCategoriesViewController.swift
//

public final class ProfileCategoriesViewController: BaseElloViewController {

    var categories = [Category]()
    public init(categories: [Category]) {
        super.init(nibName: nil, bundle: nil)
        self.categories = categories
        modalTransitionStyle = .CrossDissolve
        modalPresentationStyle = .Custom
        transitioningDelegate = self
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

// MARK: UIViewControllerTransitioningDelegate
extension ProfileCategoriesViewController: UIViewControllerTransitioningDelegate {

    public func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController?, sourceViewController source: UIViewController) -> UIPresentationController? {
        guard presented == self
            else { return .None }

        return ProfileCategoriesPresentationController(presentedViewController: presented, presentingViewController: presenting, backgroundColor: .modalBackground())
    }
}

extension ProfileCategoriesViewController: ProfileCategoriesDelegate {

    public func categoryTapped(category: Category) {
        Tracker.sharedTracker.categoryOpened(categoryOpened.slug)
        let vc = CategoryViewController(slug: category.slug)
        vc.currentUser = currentUser

        navigationController?.pushViewController(vc, animated: true)
    }

    public func dismiss() {
        dismissViewControllerAnimated(true, completion: .None)
    }
}
