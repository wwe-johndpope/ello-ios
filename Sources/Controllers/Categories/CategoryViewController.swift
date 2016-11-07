////
///  CategoryViewController.swift
//

public final class CategoryViewController: StreamableViewController {

    var mockScreen: CategoryScreenProtocol?
    public var screen: CategoryScreenProtocol {
        return mockScreen ?? self.view as! CategoryScreenProtocol
    }

    var navigationBar: ElloNavigationBar!
    var category: Category
    var pagePromotional: PagePromotional?
    var categoryPromotional: Promotional?
    var generator: CategoryGenerator?

    public init(category: Category) {
        self.category = category
        if category.level != .Meta {
            categoryPromotional = category.randomPromotional
        }
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadView() {
        self.title = category.name
        elloNavigationItem.title = title
        let item = UIBarButtonItem.backChevronWithTarget(self, action: #selector(backTapped(_:)))
        elloNavigationItem.leftBarButtonItems = [item]
        elloNavigationItem.fixNavBarItemPadding()

        let screen = CategoryScreen()
        screen.navigationItem = elloNavigationItem
        self.view = screen
        viewContainer = screen.streamContainer
        screen.delegate = self
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        streamViewController.streamKind = .Category(slug: category.slug)
        view.backgroundColor = .whiteColor()
        self.generator = CategoryGenerator(
            category: category,
            currentUser: currentUser,
            streamKind: self.streamViewController.streamKind,
            destination: self
        )
        scrollLogic.prevOffset = streamViewController.collectionView.contentOffset
        ElloHUD.showLoadingHudInView(streamViewController.view)
        streamViewController.initialLoadClosure = { [unowned self] in self.loadCategory() }
        streamViewController.reloadClosure = { [unowned self] in self.reloadEntireCategory() }
        streamViewController.toggleClosure = { [unowned self] isGridView in self.toggleGrid(isGridView) }

        streamViewController.loadInitialPage()
    }

    private func updateInsets() {
        updateInsets(navBar: screen.navigationBar, streamController: streamViewController)
    }

    override func showNavBars(scrollToBottom: Bool) {
        super.showNavBars(scrollToBottom)
        positionNavBar(screen.navigationBar, visible: true, withConstraint: screen.navigationBarTopConstraint)
        updateInsets()

        if scrollToBottom {
            self.scrollToBottom(streamViewController)
        }
    }

    override func hideNavBars() {
        super.hideNavBars()
        positionNavBar(screen.navigationBar, visible: false, withConstraint: screen.navigationBarTopConstraint, animated: true)
        updateInsets()
    }

    func toggleGrid(isGridView: Bool) {
        generator?.toggleGrid()
    }
}

private extension CategoryViewController {

    func setupNavigationBar() {
        assignRightButtons()
    }

    func loadCategory() {
        generator?.load()
    }

    func reloadEntireCategory() {
        pagePromotional = nil
        categoryPromotional = nil
        category.randomPromotional = nil
        generator?.load(reload: true)
    }

    private func assignRightButtons() {
        let rightBarButtonItems: [UIBarButtonItem] = [
            UIBarButtonItem(image: .Search, target: self, action: #selector(BaseElloViewController.searchButtonTapped))
        ]

        guard elloNavigationItem.rightBarButtonItems != nil else {
            elloNavigationItem.rightBarButtonItems = rightBarButtonItems
            return
        }

        if !elloNavigationItem.areRightButtonsTheSame(rightBarButtonItems) {
            elloNavigationItem.rightBarButtonItems = rightBarButtonItems
        }
    }
}

// MARK: CategoryViewController: StreamDestination
extension CategoryViewController: StreamDestination {

    public var pagingEnabled: Bool {
        get { return streamViewController.pagingEnabled }
        set { streamViewController.pagingEnabled = newValue }
    }

    public func replacePlaceholder(type: StreamCellType.PlaceholderType, items: [StreamCellItem], completion: ElloEmptyCompletion) {
        streamViewController.replacePlaceholder(type, with: items, completion: completion)
    }

    public func setPlaceholders(items: [StreamCellItem]) {
        streamViewController.clearForInitialLoad()
        streamViewController.appendUnsizedCellItems(items, withWidth: view.frame.width) { _ in }
    }

    public func setPrimaryJSONAble(jsonable: JSONAble) {
        if let category = jsonable as? Category {
            self.category = category

            if let categoryPromotional = self.categoryPromotional {
                category.randomPromotional = categoryPromotional
            }
            else {
                categoryPromotional = category.randomPromotional
            }

            self.title = category.name
        }
        else if let pagePromotional = jsonable as? PagePromotional {
            self.pagePromotional = pagePromotional
        }
    }

    public func primaryJSONAbleNotFound() {
        self.streamViewController.doneLoading()
    }

    public func setPagingConfig(responseConfig: ResponseConfig) {
        streamViewController.responseConfig = responseConfig
    }

}

extension CategoryViewController: CategoryScreenDelegate {

}
