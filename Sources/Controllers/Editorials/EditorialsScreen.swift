////
///  EditorialsScreen.swift
//

class EditorialsScreen: StreamableScreen, HomeScreenNavBar, EditorialsScreenProtocol {
    weak var delegate: EditorialsScreenDelegate?

    override func arrange() {
        super.arrange()

        arrangeHomeScreenNavBar(type: .editorials, navigationBar: navigationBar)
    }

    @objc
    func homeScreenFollowingTapped() {
        let responder: HomeResponder? = self.findResponder()
        responder?.showFollowingViewController()
    }
}
