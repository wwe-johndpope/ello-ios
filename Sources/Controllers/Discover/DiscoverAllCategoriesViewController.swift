////
///  DiscoverAllCategoriesViewController.swift
//

public class DiscoverAllCategoriesViewController: StreamableViewController {

    override public var tabBarItem: UITabBarItem? {
        get { return UITabBarItem.item(.Sparkles, insets: UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)) }
        set { self.tabBarItem = newValue }
    }

    var screen: DiscoverAllCategoriesScreen { return self.view as! DiscoverAllCategoriesScreen }

    required public init() {
        super.init(nibName: nil, bundle: nil)

        streamViewController.initialLoadClosure = { [unowned self] in self.loadCategories() }
        streamViewController.streamKind = .AllCategories
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadView() {
        title = InterfaceString.Discover.Title

        if !isRootViewController() {
            let item = UIBarButtonItem.backChevron(withController: self)
            self.elloNavigationItem.leftBarButtonItems = [item]
            self.elloNavigationItem.fixNavBarItemPadding()
        }

        elloNavigationItem.rightBarButtonItem = UIBarButtonItem.searchItem(controller: self)

        let screen = DiscoverAllCategoriesScreen()
        screen.navigationItem = elloNavigationItem
        self.view = screen
        viewContainer = screen.streamContainer
    }

    func loadCategories() {
        CategoryService().loadCategories().onSuccess { [weak self] categories in
            guard let sself = self else { return }

            let sortedCategories = CategoryList(categories: categories).categories

            sself.streamViewController.showInitialJSONAbles(sortedCategories)
        }.ignoreFailures()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        scrollLogic.prevOffset = streamViewController.collectionView.contentOffset
        ElloHUD.showLoadingHudInView(streamViewController.view)
        streamViewController.loadInitialPage()
    }

    private func updateInsets() {
        updateInsets(navBar: screen.navigationBar, streamController: streamViewController)
    }

    override public func showNavBars(scrollToBottom: Bool) {
        super.showNavBars(scrollToBottom)
        positionNavBar(screen.navigationBar, visible: true, withConstraint: screen.navigationBarTopConstraint)
        updateInsets()

        if scrollToBottom {
            self.scrollToBottom(streamViewController)
        }
    }

    override public func hideNavBars() {
        super.hideNavBars()
        positionNavBar(screen.navigationBar, visible: false, withConstraint: screen.navigationBarTopConstraint)
        updateInsets()
    }

}

// MARK: StreamViewDelegate
extension DiscoverAllCategoriesViewController {

    override public func streamViewStreamCellItems(jsonables: [JSONAble], defaultGenerator generator: StreamCellItemGenerator) -> [StreamCellItem]? {
        var items: [StreamCellItem] = [StreamCellItem(jsonable: CategoryList.metaCategories(), type: .CategoryList)]
        if let categories = jsonables as? [Category] {
            items += categories.map { StreamCellItem(jsonable: $0, type: .CategoryCard) }
        }
        return items
    }
}
