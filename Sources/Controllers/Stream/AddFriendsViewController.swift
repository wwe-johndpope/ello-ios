////
///  AddFriendsViewController.swift
//

public class AddFriendsViewController: StreamableViewController {

    let addressBook: AddressBookProtocol

    var _mockScreen: SearchScreenProtocol?
    public var screen: SearchScreenProtocol {
        set(screen) { _mockScreen = screen }
        get { return _mockScreen ?? self.view as! SearchScreen }
    }
    public var searchScreen: SearchScreen!

    required public init(addressBook: AddressBookProtocol) {
        self.addressBook = addressBook
        super.init(nibName: nil, bundle: nil)
        streamViewController.initialLoadClosure = { [unowned self] in self.findFriendsFromContacts() }
        streamViewController.pullToRefreshEnabled = false
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadView() {
        searchScreen = SearchScreen(frame: UIScreen.mainScreen().bounds,
            isSearchView: false,
            navBarTitle: InterfaceString.Friends.FindAndInvite,
            fieldPlaceholderText: InterfaceString.Friends.SearchPrompt)
        self.view = searchScreen
        searchScreen.delegate = self
        searchScreen.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: .Search, target: self, action: #selector(BaseElloViewController.searchButtonTapped)),
        ]
    }

    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        screen.hasBackButton = (navigationController != nil)
    }

    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if isMovingToParentViewController() || presentingViewController != nil {
            showNavBars(false)
            updateInsets()
            ElloHUD.showLoadingHudInView(streamViewController.view)
            streamViewController.loadInitialPage()
        }
    }

    override func viewForStream() -> UIView {
        return screen.viewForStream()
    }

    override func showNavBars(scrollToBottom: Bool) {
        super.showNavBars(scrollToBottom)
        if let ss = self.view as? SearchScreen {
            positionNavBar(ss.navigationBar, visible: true)
            ss.showNavBars()
        }
        updateInsets()

        if scrollToBottom {
            self.scrollToBottom(streamViewController)
        }
    }

    override func hideNavBars() {
        super.hideNavBars()
        if let ss = self.view as? SearchScreen {
            positionNavBar(ss.navigationBar, visible: false)
            ss.hideNavBars()
        }
        updateInsets()
    }

    private func updateInsets() {
        if let ss = self.view as? SearchScreen {
            updateInsets(navBar: ss.navigationBar, streamController: streamViewController, navBarsVisible: false)
        }
    }

    public func setContacts(contacts: [(LocalPerson, User?)]) {
        let items = AddressBookHelpers.process(contacts, currentUser: currentUser)
        streamViewController.appendStreamCellItems(items)
    }

    // MARK: - Private

    private func findFriendsFromContacts() {
        InviteService().find(addressBook,
            currentUser: self.currentUser,
            success: { mixedContacts in
                self.streamViewController.clearForInitialLoad()
                self.setContacts(mixedContacts)
                self.streamViewController.doneLoading()
            },
            failure: { _ in
                let mixedContacts: [(LocalPerson, User?)] = self.addressBook.localPeople.map { ($0, .None) }
                self.setContacts(mixedContacts)
                self.streamViewController.doneLoading()
            })
    }
}

extension AddFriendsViewController: SearchScreenDelegate {

    public func searchCanceled() {
        if let navigationController = navigationController {
            navigationController.popViewControllerAnimated(true)
        }
        else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

    public func searchFieldCleared() {
        streamViewController.streamFilter = nil
    }

    public func searchFieldChanged(text: String, isPostSearch: Bool) {
        streamViewController.streamFilter = AddressBookHelpers.searchFilter(text)
    }

    public func searchShouldReset() {
        // noop
    }

    public func toggleChanged(text: String, isPostSearch: Bool) {
        // do nothing as this should not be visible
    }

    public func findFriendsTapped() {
        // noop
    }

}
