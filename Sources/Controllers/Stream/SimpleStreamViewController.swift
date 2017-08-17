////
///  SimpleStreamController.swift
//

class SimpleStreamViewController: StreamableViewController {
    override func trackerName() -> String? {
        return endpoint.trackerName
    }
    override func trackerStreamInfo() -> (String, String?)? {
        guard let streamKind = endpoint.trackerStreamKind else { return nil }
        return (streamKind, endpoint.trackerStreamId)
    }

    var navigationBar: ElloNavigationBar!
    let endpoint: ElloAPI

    required init(endpoint: ElloAPI, title: String) {
        self.endpoint = endpoint
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let streamKind = StreamKind.simpleStream(endpoint: endpoint, title: title ?? "")

        setupNavigationBar()
        setupNavigationItems(streamKind: streamKind)

        streamViewController.streamKind = streamKind
        ElloHUD.showLoadingHudInView(streamViewController.view)
        streamViewController.loadInitialPage()
    }

    override func viewForStream() -> UIView {
        return view
    }

    override func showNavBars() {
        super.showNavBars()
        positionNavBar(navigationBar, visible: true)
        updateInsets()
    }

    override func hideNavBars() {
        super.hideNavBars()
        positionNavBar(navigationBar, visible: false)
        updateInsets()
    }

    // MARK: Private

    fileprivate func updateInsets() {
        updateInsets(navBar: navigationBar)
    }

    fileprivate func setupNavigationBar() {
        navigationBar = ElloNavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: ElloNavigationBar.Size.height))
        navigationBar.autoresizingMask = [.flexibleBottomMargin, .flexibleWidth]
        view.addSubview(navigationBar)
    }

    fileprivate func setupNavigationItems(streamKind: StreamKind) {
        let backItem = UIBarButtonItem.backChevron(withController: self)
        elloNavigationItem.leftBarButtonItems = [backItem]
        elloNavigationItem.fixNavBarItemPadding()
        navigationBar.items = [elloNavigationItem]

        if streamKind.hasGridViewToggle {
            elloNavigationItem.rightBarButtonItem = UIBarButtonItem.gridListItem(delegate: streamViewController, isGridView: streamKind.isGridView)
        }
    }

}
