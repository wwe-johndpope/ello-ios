////
///  ArtistInviteAdminScreen.swift
//

class ArtistInviteAdminScreen: StreamableScreen, ArtistInviteAdminScreenProtocol {
    weak var delegate: ArtistInviteAdminScreenDelegate?

    fileprivate var tabBar = NestedTabBarView()
    fileprivate var approvedTab: NestedTabBarView.Tab!
    fileprivate var selectedTab: NestedTabBarView.Tab!
    fileprivate var unapprovedTab: NestedTabBarView.Tab!

    var selectedSubmissionsStatus: ArtistInviteSubmission.Status = .approved {
        didSet {
            switch selectedSubmissionsStatus {
            case .approved: tabBar.select(tab: approvedTab)
            case .selected: tabBar.select(tab: selectedTab)
            case .unapproved: tabBar.select(tab: unapprovedTab)
            case .unspecified: break
            }
        }
    }

    override func style() {
        super.style()
        navigationBar.sizeClass = .large
    }

    override func arrange() {
        super.arrange()

        let titleLabel = StyledLabel(style: .header)
        titleLabel.text = InterfaceString.ArtistInvites.AdminTitle

        navigationBar.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(navigationBar)
            make.top.equalTo(navigationBar).offset(BlackBar.Size.height + HomeScreenNavBarSize.typeOffset)
        }

        unapprovedTab = tabBar.createTab(title: InterfaceString.ArtistInvites.AdminUnapprovedTab)
        unapprovedTab.addTarget(self, action: #selector(tappedUnapprovedSubmissions))
        approvedTab = tabBar.createTab(title: InterfaceString.ArtistInvites.AdminApprovedTab)
        approvedTab.addTarget(self, action: #selector(tappedApprovedSubmissions))
        selectedTab = tabBar.createTab(title: InterfaceString.ArtistInvites.AdminSelectedTab)
        selectedTab.addTarget(self, action: #selector(tappedSelectedSubmissions))

        tabBar.addTab(unapprovedTab)
        tabBar.addTab(approvedTab)
        tabBar.addTab(selectedTab)
        tabBar.select(tab: approvedTab)

        navigationBar.sizeClass = .large
        navigationBar.addSubview(tabBar)
        tabBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(navigationBar)
        }
    }

}

extension ArtistInviteAdminScreen {

    func tappedApprovedSubmissions() {
        delegate?.tappedApprovedSubmissions()
    }

    func tappedSelectedSubmissions() {
        delegate?.tappedSelectedSubmissions()
    }

    func tappedUnapprovedSubmissions() {
        delegate?.tappedUnapprovedSubmissions()
    }
}
