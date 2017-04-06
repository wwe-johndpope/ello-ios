////
///  SearchScreen.swift
//

class SearchScreen: StreamableScreen, SearchScreenProtocol {
    struct Size {
        static let margin: CGFloat = 15
        static let buttonWidth: CGFloat = 40
        static let searchControlsHeight: CGFloat = 30
        static let cornerRadius: CGFloat = 5
        static let findFriendsInsets = UIEdgeInsets(all: 20)
        static let findFriendsLabelLeft: CGFloat = 25
        static let findFriendsButtonHeight: CGFloat = 44
    }

    weak var delegate: SearchScreenDelegate?

    let searchField = SearchNavBarField()
    let searchControlsContainer = UIView()
    var showsFindFriends: Bool = true {
        didSet { showHideFindFriends() }
    }

    fileprivate let debounced: ThrottledBlock = debounce(0.8)
    fileprivate let backButton = UIButton()
    fileprivate let postsToggleButton = SearchToggleButton()
    fileprivate let peopleToggleButton = SearchToggleButton()
    fileprivate let findFriendsContainer = UIView()
    fileprivate let findFriendsButton = StyledButton(style: .green)
    fileprivate let findFriendsLabel = StyledLabel(style: .black)
    fileprivate var bottomInset: CGFloat = 0

    override func setText() {
        searchField.placeholder = InterfaceString.Friends.SearchPrompt
        postsToggleButton.setTitle(InterfaceString.Search.Posts, for: .normal)
        peopleToggleButton.setTitle(InterfaceString.Search.People, for: .normal)
        findFriendsButton.setTitle(InterfaceString.Friends.FindAndInvite, for: .normal)
        findFriendsLabel.text = InterfaceString.Search.FindFriendsPrompt
    }

    override func bindActions() {
        searchField.addTarget(self, action: #selector(searchFieldDidChange), for: .editingChanged)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        postsToggleButton.addTarget(self, action: #selector(onPostsTapped), for: .touchUpInside)
        peopleToggleButton.addTarget(self, action: #selector(onPeopleTapped), for: .touchUpInside)
        findFriendsButton.addTarget(self, action: #selector(findFriendsTapped), for: .touchUpInside)
        searchField.delegate = self
    }

    override func style() {
        backButton.setImages(.angleBracket, degree: 180)

        searchControlsContainer.backgroundColor = .white

        findFriendsContainer.backgroundColor = .greyF2()
        findFriendsContainer.isHidden = !showsFindFriends
        findFriendsContainer.layer.cornerRadius = Size.cornerRadius
        findFriendsContainer.clipsToBounds = true

        postsToggleButton.isSelected = true
        peopleToggleButton.isSelected = false
    }

    override func arrange() {
        super.arrange()

        navigationBar.addSubview(backButton)
        navigationBar.addSubview(searchField)

        addSubview(searchControlsContainer)
        searchControlsContainer.addSubview(postsToggleButton)
        searchControlsContainer.addSubview(peopleToggleButton)

        addSubview(findFriendsContainer)
        findFriendsContainer.addSubview(findFriendsLabel)
        findFriendsContainer.addSubview(findFriendsButton)

        backButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(navigationBar)
            make.top.equalTo(navigationBar).offset(BlackBar.Size.height)
            make.width.equalTo(Size.buttonWidth)
        }

        searchField.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing)
            make.bottom.top.trailing.equalTo(navigationBar).inset(SearchNavBarField.Size.searchInsets)
        }

        searchControlsContainer.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(Size.searchControlsHeight)
        }

        postsToggleButton.snp.makeConstraints { make in
            make.leading.equalTo(searchControlsContainer).offset(Size.margin)
            make.top.bottom.equalTo(searchControlsContainer)
        }

        peopleToggleButton.snp.makeConstraints { make in
            make.trailing.equalTo(searchControlsContainer).offset(-Size.margin)
            make.leading.equalTo(postsToggleButton.snp.trailing)
            make.width.equalTo(postsToggleButton)
            make.top.bottom.equalTo(searchControlsContainer)
        }

        findFriendsContainer.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(Size.margin)
            make.bottom.equalTo(keyboardAnchor.snp.top).offset(-Size.margin)
            make.bottom.lessThanOrEqualTo(self).inset(ElloTabBar.Size.height).priority(Priority.required)
        }

        findFriendsLabel.snp.makeConstraints { make in
            make.leading.equalTo(findFriendsContainer).offset(Size.findFriendsLabelLeft)
            make.top.trailing.equalTo(findFriendsContainer).inset(Size.findFriendsInsets)
        }

        findFriendsButton.snp.makeConstraints { make in
            make.top.equalTo(findFriendsLabel.snp.bottom).offset(Size.findFriendsInsets.top)
            make.bottom.leading.trailing.equalTo(findFriendsContainer).inset(Size.findFriendsInsets)
            make.height.equalTo(Size.findFriendsButtonHeight)
        }
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        searchField.becomeFirstResponder()
    }

}

extension SearchScreen {

    func showNavBars() {
        animate {
            self.searchControlsContainer.frame.origin.y = self.navigationBar.frame.size.height
        }
    }

    func hideNavBars() {
        animate {
            self.searchControlsContainer.frame.origin.y = -1
        }
    }

    func updateInsets(bottom: CGFloat) {
        bottomInset = bottom
        setNeedsLayout()
    }

    func searchFor(_ text: String) {
        searchField.text = text
        performSearch()
    }

}

extension SearchScreen {

    fileprivate func clearSearch() {
        delegate?.searchFieldCleared()
        debounced {}
    }

    fileprivate func performSearch() {
        guard
            let text = searchField.text,
            text.characters.count > 0
        else { return }

        showHideFindFriends()
        delegate?.searchFieldChanged(text, isPostSearch: postsToggleButton.isSelected)
    }

// MARK: actions

    @objc
    func onPostsTapped() {
        postsToggleButton.isSelected = true
        peopleToggleButton.isSelected = false
        var searchFieldText = searchField.text ?? ""
        if searchFieldText == "@" {
            searchFieldText = ""
        }
        searchField.text = searchFieldText
        delegate?.toggleChanged(searchFieldText, isPostSearch: postsToggleButton.isSelected)
    }

    @objc
    func onPeopleTapped() {
        peopleToggleButton.isSelected = true
        postsToggleButton.isSelected = false
        var searchFieldText = searchField.text ?? ""
        if searchFieldText == "" {
            searchFieldText = "@"
        }
        searchField.text = searchFieldText
        delegate?.toggleChanged(searchFieldText, isPostSearch: postsToggleButton.isSelected)
    }

    @objc
    func backTapped() {
        delegate?.searchCanceled()
    }

    @objc
    func findFriendsTapped() {
        delegate?.findFriendsTapped()
    }

    @objc
    func searchFieldDidChange() {
        delegate?.searchShouldReset()
        let text = searchField.text ?? ""
        if text.characters.count == 0 {
            clearSearch()
            showHideFindFriends()
        }
        else {
            debounced { [weak self] in
                self?.performSearch()
            }
        }
    }

}

extension SearchScreen: UITextFieldDelegate {

    @objc
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        clearSearch()
        showHideFindFriends()
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        _ = textField.resignFirstResponder()
        return true
    }

}

extension SearchScreen {

    fileprivate func showHideFindFriends() {
        if showsFindFriends && searchField.text.isEmpty {
            findFriendsContainer.isHidden = false
        }
        else {
            findFriendsContainer.isHidden = true
        }
    }

}
