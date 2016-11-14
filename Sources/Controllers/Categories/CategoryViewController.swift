////
///  CategoryViewController.swift
//

public final class CategoryViewController: StreamableViewController {

    var mockScreen: CategoryScreenProtocol?
    public var screen: CategoryScreenProtocol {
        return mockScreen ?? self.view as! CategoryScreenProtocol
    }

    var navigationBar: ElloNavigationBar!
    var category: Category?
    var slug: String
    var allCategories: [Category] = []
    var pagePromotional: PagePromotional?
    var categoryPromotional: Promotional?
    var generator: CategoryGenerator?
    var userDidScroll: Bool = false

    public init(slug: String) {
        self.slug = slug
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadView() {
        self.title = category?.name ?? slug.uppercaseFirst
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
        streamViewController.streamKind = .Category(slug: slug)
        view.backgroundColor = .whiteColor()
        self.generator = CategoryGenerator(
            slug: slug,
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
        updateInsets(navBar: screen.topInsetView, streamController: streamViewController, navBarsVisible: screen.navBarsVisible)
    }

    override func showNavBars(scrollToBottom: Bool) {
        super.showNavBars(scrollToBottom)
        positionNavBar(screen.navigationBar, visible: true, withConstraint: screen.navigationBarTopConstraint)
        screen.animateCategoriesList(navBarVisible: true)
        updateInsets()

        if scrollToBottom {
            self.scrollToBottom(streamViewController)
        }
    }

    override func hideNavBars() {
        super.hideNavBars()
        positionNavBar(screen.navigationBar, visible: false, withConstraint: screen.navigationBarTopConstraint, animated: true)
        screen.animateCategoriesList(navBarVisible: false)
        updateInsets()
    }

    func toggleGrid(isGridView: Bool) {
        generator?.toggleGrid()
    }

    override public func streamViewWillBeginDragging(scrollView: UIScrollView) {
        super.streamViewWillBeginDragging(scrollView)
        userDidScroll = true
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
        category?.randomPromotional = nil
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
extension CategoryViewController: CategoryStreamDestination, StreamDestination {

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

    public func setCategories(categories: [Category]) {
        let metaCategories = [
            Category.featured,
            Category.trending,
            Category.recent,
        ]
        allCategories = metaCategories + categories

        let shouldAnimate = !(screen.navBarsVisible ?? false)
        let info = allCategories.map { (category: Category) -> CategoryCardListView.CategoryInfo in
            return CategoryCardListView.CategoryInfo(title: category.name, imageURL: category.tileURL)
        }
        screen.setCategoriesInfo(info, animated: shouldAnimate)

        let selectedCategoryIndex = allCategories.indexOf { $0.id == category?.id }
        if let selectedCategoryIndex = selectedCategoryIndex where shouldAnimate {
            screen.scrollToCategoryIndex(selectedCategoryIndex)
        }
        updateInsets()

        if !userDidScroll && streamViewController.dataSource.visibleCellItems.count > 0 {
            var offset: CGFloat = CategoryCardListView.Size.height
            if navBarsVisible() {
                offset += ElloNavigationBar.Size.height
            }
            offset -= ColumnToggleCell.Size.height
            streamViewController.collectionView.setContentOffset(CGPoint(x: 0, y: -offset), animated: true)
            userDidScroll = true  // don't do this animation again, e.g. if the user chooses a new category
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

    public func selectCategoryForSlug(slug: String) {
        guard let category = categoryForSlug(slug) else { return }
        selectCatgory(category)
    }

    private func categoryForSlug(slug: String) -> Category? {
        return allCategories.filter { $0.slug == slug }.first
    }

    public func categorySelected(index: Int) {
        guard
            let category = allCategories.safeValue(index)
        where category.id != self.category?.id
        else { return }

        selectCatgory(category)
    }

    public func selectCatgory(category: Category) {
		Tracker.sharedTracker.categoryOpened(category.slug)
        let streamKind: StreamKind
        switch category.level {
        case .Meta:
            streamKind = .Discover(type: DiscoverType(rawValue: category.slug)!)
        default:
            streamKind = .Category(slug: category.slug)
        }
        category.randomPromotional = nil
        streamViewController.streamKind = streamKind
        generator?.reset(streamKind: streamKind, category: category, pagePromotional: nil)
        self.category = category
        self.slug = category.slug
        self.title = category.name
        reloadEntireCategory()
    }
}
