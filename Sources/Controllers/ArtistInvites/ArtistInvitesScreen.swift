////
///  ArtistInvitesScreen.swift
//

class ArtistInvitesScreen: StreamableScreen {
    weak var delegate: ArtistInvitesScreenDelegate?

    override func style() {
        super.style()
        navigationBar.sizeClass = .large
    }

    override func arrange() {
        super.arrange()

        arrangeHomeScreenNavBar(type: .artistInvites, navigationBar: navigationBar)
    }
}

extension ArtistInvitesScreen: HomeScreenNavBar {

    @objc
    func homeScreenScrollToTop() {
        delegate?.scrollToTop()
    }

    @objc
    func homeScreenEditorialsTapped() {
        let responder: HomeResponder? = self.findResponder()
        responder?.showEditorialsViewController()
    }

    @objc
    func homeScreenFollowingTapped() {
        let responder: HomeResponder? = self.findResponder()
        responder?.showFollowingViewController()
    }

}
