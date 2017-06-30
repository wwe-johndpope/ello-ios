////
///  EditorialsScreen.swift
//

class EditorialsScreen: StreamableScreen, HomeScreenNavBar, EditorialsScreenProtocol {
    weak var delegate: EditorialsScreenDelegate?
    fileprivate var usage: EditorialsViewController.Usage

    struct Size {
        static let logoTypeOffset: CGFloat = 0.5
    }

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

        if usage == .loggedIn {
            arrangeHomeScreenNavBar(type: .editorials, navigationBar: navigationBar)
        }
        else {
            let logoButton = UIButton()
            logoButton.setImage(.elloType, imageStyle: .normal, for: .normal)
            logoButton.addTarget(self, action: #selector(homeScreenScrollToTop), for: .touchUpInside)
            navigationBar.addSubview(logoButton)

            logoButton.snp.makeConstraints { make in
                make.center.equalTo(navigationBar).offset(BlackBar.Size.height / 2 + Size.logoTypeOffset)
            }
        }
    }

    @objc
    func homeScreenScrollToTop() {
        delegate?.scrollToTop()
    }

    @objc
    func homeScreenFollowingTapped() {
        let responder: HomeResponder? = self.findResponder()
        responder?.showFollowingViewController()
    }
}
