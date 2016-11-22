////
///  SearchViewController.swift
//

public class SearchViewController: StreamableViewController {
    var searchText: String?

    var _mockScreen: SearchScreenProtocol?
    public var screen: SearchScreenProtocol {
        set(screen) { _mockScreen = screen }
        get { return _mockScreen ?? self.view as! SearchScreenProtocol }
    }

    override public func loadView() {
        let screen = SearchScreen(frame: UIScreen.mainScreen().bounds, isSearchView: true)
        self.view = screen
        screen.delegate = self
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        streamViewController.pullToRefreshEnabled = false
        screen.gridListItem = UIBarButtonItem.gridListItem(delegate: streamViewController, isGridView: streamViewController.streamKind.isGridView)
        screen.hasGridViewToggle = streamViewController.streamKind.hasGridViewToggle
        updateInsets()
    }

    public func searchForPosts(terms: String) {
        screen.searchField.text = terms
        screen.searchForText()
    }

    override func viewForStream() -> UIView {
        return screen.viewForStream()
    }

    override func showNavBars(scrollToBottom: Bool) {
        super.showNavBars(scrollToBottom)
        positionNavBar(screen.navigationBar, visible: true)
        screen.showNavBars()
        updateInsets()

        if scrollToBottom {
            self.scrollToBottom(streamViewController)
        }
    }

    override func hideNavBars() {
        super.hideNavBars()
        positionNavBar(screen.navigationBar, visible: false)
        screen.hideNavBars()
        updateInsets()
    }

    private func updateInsets() {
        updateInsets(navBar: screen.searchControlsContainer, streamController: streamViewController)
    }

}

extension SearchViewController: SearchScreenDelegate {

    public func searchCanceled() {
        navigationController?.popViewControllerAnimated(true)
    }

    public func searchFieldCleared() {
        showNavBars(false)
        searchText = ""
        streamViewController.removeAllCellItems()
        streamViewController.loadingToken.cancelInitialPage()
        streamViewController.noResultsMessages = (title: "", body: "")
        screen.hasGridViewToggle = false
    }

    public func searchFieldChanged(text: String, isPostSearch: Bool) {
        loadEndpoint(text, isPostSearch: isPostSearch)
    }

    public func searchShouldReset() {
        streamViewController.hideNoResults()
    }

    public func toggleChanged(text: String, isPostSearch: Bool) {
        searchShouldReset()
        loadEndpoint(text, isPostSearch: isPostSearch, checkSearchText: false)
    }

    public func findFriendsTapped() {
        let responder = targetForAction(#selector(InviteResponder.onInviteFriends), withSender: self) as? InviteResponder
        responder?.onInviteFriends()
    }

    private func loadEndpoint(text: String, isPostSearch: Bool, checkSearchText: Bool = true) {
        if text.characters.count < 2 { return }  // just.. no (and the server doesn't guard against empty/short searches)
        if checkSearchText && searchText == text { return }  // a search is already in progress for this text
        streamViewController.hideNoResults()
        trackSearch(text, isPostSearch: isPostSearch)
        searchText = text
        let endpoint = isPostSearch ? ElloAPI.SearchForPosts(terms: text) : ElloAPI.SearchForUsers(terms: text)
        streamViewController.noResultsMessages = (title: InterfaceString.Search.NoMatches, body: InterfaceString.Search.TryAgain)
        let streamKind = StreamKind.SimpleStream(endpoint: endpoint, title: "")
        screen.hasGridViewToggle = streamKind.hasGridViewToggle
        streamViewController.streamKind = streamKind
        streamViewController.removeAllCellItems()
        ElloHUD.showLoadingHudInView(streamViewController.view)
        streamViewController.loadInitialPage()
    }

    public func trackSearch(text: String, isPostSearch: Bool) {
        if isPostSearch {
            if text.hasPrefix("#") {
                Tracker.sharedTracker.searchFor("hashtags")
            }
            else {
                Tracker.sharedTracker.searchFor("posts")
            }
        }
        else {
            Tracker.sharedTracker.searchFor("users")
        }
    }
}
