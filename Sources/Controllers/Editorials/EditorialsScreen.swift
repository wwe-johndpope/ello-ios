////
///  EditorialsScreen.swift
//

class EditorialsScreen: StreamableScreen, HomeScreenNavBar, EditorialsScreenProtocol {
    weak var delegate: EditorialsScreenDelegate?
    fileprivate var usage: EditorialsViewController.Usage

    init(usage: EditorialsViewController.Usage) {
        self.usage = usage
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init(frame: CGRect) {
        self.usage = .loggedOut
        super.init(frame: frame)
    }

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
