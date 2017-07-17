////
///  HomeScreen.swift
//


class HomeScreen: StreamableScreen, HomeScreenProtocol {
    weak var delegate: HomeScreenDelegate?
    let controllerContainer = UIView()

    override func arrange() {
        super.arrange()

        addSubview(controllerContainer)

        controllerContainer.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}


@objc
protocol HomeScreenNavBar: class {
    @objc func homeScreenScrollToTop()
    @objc optional func homeScreenEditorialsTapped()
    @objc optional func homeScreenFollowingTapped()
    @objc optional func homeScreenDiscoverTapped()
}

struct HomeScreenNavBarSize {
    static let margins: CGFloat = 15
    static let logoButtonMargin: CGFloat = 5
    static let typeOffset: CGFloat = 18.625
    static let buttonHeight: CGFloat = 40
    static let lineThickness: CGFloat = 1
}

fileprivate typealias Size = HomeScreenNavBarSize

enum HomeScreenType {
    case editorials(loggedIn: Bool)
    case following
    case discover
}

extension HomeScreenNavBar {

    func arrangeHomeScreenNavBar(type: HomeScreenType, navigationBar: UIView) {
        let logoButton = UIButton()
        navigationBar.addSubview(logoButton)
        logoButton.setImage(.elloType, imageStyle: .normal, for: .normal)
        logoButton.addTarget(self, action: #selector(homeScreenScrollToTop), for: .touchUpInside)

        let editorialsButton = StyledButton()
        editorialsButton.setTitle(InterfaceString.Editorials.NavbarTitle, for: .normal)
        navigationBar.addSubview(editorialsButton)

        let editorialsLine = UIView()
        editorialsButton.addSubview(editorialsLine)

        let otherButton = StyledButton()
        navigationBar.addSubview(otherButton)

        let otherLine = UIView()
        otherButton.addSubview(otherLine)

        switch type {
        case let .editorials(loggedIn):
            editorialsButton.style = .clearBlack
            editorialsLine.backgroundColor = .black

            otherButton.style = .clearGray
            otherLine.backgroundColor = .greyA()
            if loggedIn {
                otherButton.setTitle(InterfaceString.Following.Title, for: .normal)
                otherButton.addTarget(self, action: #selector(homeScreenFollowingTapped), for: .touchUpInside)
            }
            else {
                otherButton.setTitle(InterfaceString.Discover.Title, for: .normal)
                otherButton.addTarget(self, action: #selector(homeScreenDiscoverTapped), for: .touchUpInside)
            }
        case .following:
            editorialsButton.style = .clearGray
            editorialsButton.addTarget(self, action: #selector(homeScreenEditorialsTapped), for: .touchUpInside)
            editorialsLine.backgroundColor = .greyA()

            otherButton.style = .clearBlack
            otherButton.setTitle(InterfaceString.Following.Title, for: .normal)
            otherLine.backgroundColor = .black
        case .discover:
            editorialsButton.style = .clearGray
            editorialsButton.addTarget(self, action: #selector(homeScreenEditorialsTapped), for: .touchUpInside)
            editorialsLine.backgroundColor = .greyA()

            otherButton.style = .clearBlack
            otherButton.setTitle(InterfaceString.Discover.Title, for: .normal)
            otherLine.backgroundColor = .black
        }

        logoButton.snp.makeConstraints { make in
            make.centerX.equalTo(navigationBar)
            make.top.equalTo(navigationBar).offset(BlackBar.Size.height + HomeScreenNavBarSize.typeOffset)
        }

        editorialsButton.snp.makeConstraints { make in
            make.leading.equalTo(navigationBar).inset(Size.margins)
            make.trailing.equalTo(otherButton.snp.leading)
            make.top.equalTo(logoButton.snp.bottom).offset(Size.logoButtonMargin)
            make.height.equalTo(Size.buttonHeight)
            make.width.equalTo(otherButton)
        }
        editorialsLine.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(editorialsButton)
            make.height.equalTo(Size.lineThickness)
        }
        otherButton.snp.makeConstraints { make in
            make.trailing.equalTo(navigationBar).inset(Size.margins)
            make.top.equalTo(logoButton.snp.bottom).offset(Size.logoButtonMargin)
            make.height.equalTo(Size.buttonHeight)
        }
        otherLine.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(otherButton)
            make.height.equalTo(Size.lineThickness)
        }
    }
}
