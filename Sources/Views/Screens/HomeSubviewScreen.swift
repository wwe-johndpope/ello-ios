////
///  HomeSubviewScreen.swift
//

class HomeSubviewScreen: StreamableScreen {
}

extension HomeSubviewScreen {

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

    @objc
    func homeScreenDiscoverTapped() {
        let responder: HomeResponder? = self.findResponder()
        responder?.showDiscoverViewController()
    }

    @objc
    func homeScreenArtistInvitesTapped() {
        let responder: HomeResponder? = self.findResponder()
        responder?.showArtistInvitesViewController()
    }

}
