////
///  ArtistInviteDetailController.swift
//

class ArtistInviteDetailController: StreamableViewController {
    override func trackerName() -> String? { return "ArtistInvite" }
    override func trackerProps() -> [String: Any]? { return ["id": artistInvite.id] }
    override func trackerStreamInfo() -> (String, String?)? { return nil }

    let artistInvite: ArtistInvite

    private var _mockScreen: ArtistInviteDetailScreenProtocol?
    var screen: ArtistInviteDetailScreenProtocol {
        set(screen) { _mockScreen = screen }
        get { return _mockScreen ?? self.view as! ArtistInviteDetailScreen }
    }
    var generator: ArtistInviteDetailGenerator!

    init(artistInvite: ArtistInvite) {
        self.artistInvite = artistInvite
        super.init(nibName: nil, bundle: nil)

        title = artistInvite.title
        generator = ArtistInviteDetailGenerator(
            artistInvite: artistInvite,
            currentUser: currentUser,
            destination: self)
        streamViewController.streamKind = generator.streamKind
        streamViewController.initialLoadClosure = { [weak self] in self?.loadArtistInviteDetail() }
   }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didSetCurrentUser() {
        generator.currentUser = currentUser
        super.didSetCurrentUser()
    }

    override func loadView() {
        let screen = ArtistInviteDetailScreen()
        screen.delegate = self

        let backItem = UIBarButtonItem.backChevronWithTarget(self, action: #selector(backTapped))
        elloNavigationItem.leftBarButtonItem = backItem
        elloNavigationItem.fixNavBarItemPadding()
        screen.navigationItem = elloNavigationItem

        self.view = screen
        viewContainer = screen.streamContainer
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        ElloHUD.showLoadingHudInView(streamViewController.view)
        streamViewController.loadInitialPage()
    }

    fileprivate func updateInsets() {
        updateInsets(navBar: screen.navigationBar)
    }

    override func showNavBars() {
        super.showNavBars()
        positionNavBar(screen.navigationBar, visible: true, withConstraint: screen.navigationBarTopConstraint)
        updateInsets()
    }

    override func hideNavBars() {
        super.hideNavBars()
        positionNavBar(screen.navigationBar, visible: false, withConstraint: screen.navigationBarTopConstraint)
        updateInsets()
    }

}

extension ArtistInviteDetailController: StreamDestination {

    var pagingEnabled: Bool {
        get { return streamViewController.pagingEnabled }
        set { streamViewController.pagingEnabled = newValue }
    }

    func loadArtistInviteDetail() {
        streamViewController.pagingEnabled = false
        generator.load()
    }

    func replacePlaceholder(type: StreamCellType.PlaceholderType, items: [StreamCellItem], completion: @escaping Block) {
        streamViewController.replacePlaceholder(type: type, items: items, completion: completion)
        streamViewController.doneLoading()
    }

    func setPlaceholders(items: [StreamCellItem]) {
        streamViewController.clearForInitialLoad()
        streamViewController.appendStreamCellItems(items)
    }

    func setPrimary(jsonable: JSONAble) {
    }

    func setPagingConfig(responseConfig: ResponseConfig) {
        streamViewController.responseConfig = responseConfig
    }

    func primaryJSONAbleNotFound() {
        self.showGenericLoadFailure()
        self.streamViewController.doneLoading()
    }

}

extension ArtistInviteDetailController: ArtistInviteResponder {
    func tappedArtistInviteSubmissionsButton() {
        streamViewController.scrollTo(placeholderType: .artistInviteSubmissions, animated: true)
    }

    func tappedArtistInviteSubmitButton() {
        let vc = OmnibarViewController()
        vc.artistInviteId = artistInvite.id
        vc.currentUser = currentUser
        vc.onPostSuccess { _ in
            _ = self.navigationController?.popViewController(animated: true)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension ArtistInviteDetailController: ArtistInviteDetailScreenDelegate {}
