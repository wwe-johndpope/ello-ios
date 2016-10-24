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
    var generator: CategoryGenerator?

    public init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadView() {
        let screen = CategoryScreen(category: category)
        screen.delegate = self
        self.view = screen
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        streamViewController.streamKind = .Category(categoryName: category.slug)
        view.backgroundColor = .whiteColor()
        self.generator = CategoryGenerator(
            category: category,
            currentUser: currentUser,
            streamKind: self.streamViewController.streamKind,
            destination: self
        )
        ElloHUD.showLoadingHudInView(streamViewController.view)
        streamViewController.initialLoadClosure = { [unowned self] in self.loadCategory() }
        streamViewController.reloadClosure = { [unowned self] in self.reloadEntireCategory() }

        streamViewController.loadInitialPage()
    }

    override func viewForStream() -> UIView {
        return view
    }
}

private extension CategoryViewController {

    func setupNavigationBar() {
        navigationBar = ElloNavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: ElloNavigationBar.Size.height))
        navigationBar.autoresizingMask = [.FlexibleBottomMargin, .FlexibleWidth]
        view.addSubview(navigationBar)
        let item = UIBarButtonItem.backChevronWithTarget(self, action: #selector(StreamableViewController.backTapped(_:)))
        elloNavigationItem.leftBarButtonItems = [item]
        elloNavigationItem.fixNavBarItemPadding()
        navigationBar.items = [elloNavigationItem]
        assignRightButtons()
    }

    func loadCategory() {
        generator?.load()
    }

    func reloadEntireCategory() {
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

    public func replacePlaceholder(type: StreamCellType.PlaceholderType, @autoclosure items: () -> [StreamCellItem], completion: ElloEmptyCompletion) {
        streamViewController.replacePlaceholder(type, with: items, completion: completion)
    }

    public func setPlaceholders(items: [StreamCellItem]) {
        streamViewController.clearForInitialLoad()
        streamViewController.appendUnsizedCellItems(items, withWidth: view.frame.width) { _ in }
    }

    public func setPrimaryJSONAble(jsonable: JSONAble) {
        guard let category = jsonable as? Category else { return }

        self.category = category

        self.title = category.name
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
