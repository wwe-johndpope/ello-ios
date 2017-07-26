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
    @objc optional func homeScreenArtistInvitesTapped()
    @objc optional func homeScreenFollowingTapped()
    @objc optional func homeScreenDiscoverTapped()
}

struct HomeScreenNavBarSize {
    static let margins: CGFloat = 15
    static let tabSpacing: CGFloat = 1
    static let logoButtonMargin: CGFloat = 5
    static let typeOffset: CGFloat = 18.625
    static let buttonHeight: CGFloat = 40
    static let lineThickness: CGFloat = 1
}

fileprivate typealias Size = HomeScreenNavBarSize

enum HomeScreenType {
    case editorials(loggedIn: Bool)
    case artistInvites
    case following
    case discover

    var tabCount: Int {
        switch self {
        case let .editorials(loggedIn):
            return loggedIn ? 3 : 2
        case .artistInvites, .following:
            return 3
        case .discover:
            return 2
        }
    }
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

        let middleButton = StyledButton()
        middleButton.setTitle(InterfaceString.ArtistInvites.Title, for: .normal)
        let middleLine = UIView()

        switch type {
        case let .editorials(loggedIn):
            editorialsButton.style = .clearBlack
            editorialsLine.backgroundColor = .black

            otherButton.style = .clearGray
            otherLine.backgroundColor = .greyA

            if loggedIn {
                otherButton.setTitle(InterfaceString.Following.Title, for: .normal)
                otherButton.addTarget(self, action: #selector(homeScreenFollowingTapped), for: .touchUpInside)
            }
            else {
                otherButton.setTitle(InterfaceString.Discover.Title, for: .normal)
                otherButton.addTarget(self, action: #selector(homeScreenDiscoverTapped), for: .touchUpInside)
            }

            middleButton.style = .clearGray
            middleButton.addTarget(self, action: #selector(homeScreenArtistInvitesTapped), for: .touchUpInside)
            middleLine.backgroundColor = .greyA
        case .following:
            editorialsButton.style = .clearGray
            editorialsButton.addTarget(self, action: #selector(homeScreenEditorialsTapped), for: .touchUpInside)
            editorialsLine.backgroundColor = .greyA

            otherButton.style = .clearBlack
            otherButton.setTitle(InterfaceString.Following.Title, for: .normal)
            otherLine.backgroundColor = .black

            middleButton.style = .clearGray
            middleButton.addTarget(self, action: #selector(homeScreenArtistInvitesTapped), for: .touchUpInside)
            middleLine.backgroundColor = .greyA
        case .artistInvites:
            editorialsButton.style = .clearGray
            editorialsButton.addTarget(self, action: #selector(homeScreenEditorialsTapped), for: .touchUpInside)
            editorialsLine.backgroundColor = .greyA

            otherButton.style = .clearGray
            otherButton.setTitle(InterfaceString.Following.Title, for: .normal)
            otherButton.addTarget(self, action: #selector(homeScreenFollowingTapped), for: .touchUpInside)
            otherLine.backgroundColor = .greyA

            middleButton.style = .clearBlack
            middleLine.backgroundColor = .black
        case .discover:
            editorialsButton.style = .clearGray
            editorialsButton.addTarget(self, action: #selector(homeScreenEditorialsTapped), for: .touchUpInside)
            editorialsLine.backgroundColor = .greyA

            otherButton.style = .clearBlack
            otherButton.setTitle(InterfaceString.Discover.Title, for: .normal)
            otherLine.backgroundColor = .black
        }

        logoButton.snp.makeConstraints { make in
            make.centerX.equalTo(navigationBar)
            make.top.equalTo(navigationBar).offset(BlackBar.Size.height + HomeScreenNavBarSize.typeOffset)
        }

        if type.tabCount == 3 {
            navigationBar.addSubview(middleButton)
            middleButton.addSubview(middleLine)
        }

        editorialsButton.snp.makeConstraints { make in
            make.leading.equalTo(navigationBar).inset(Size.margins)
            make.top.equalTo(logoButton.snp.bottom).offset(Size.logoButtonMargin)
            make.height.equalTo(Size.buttonHeight)
            make.width.equalTo(otherButton)
        }
        editorialsLine.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(editorialsButton)
            make.height.equalTo(Size.lineThickness)
        }

        if type.tabCount == 3 {
            middleButton.snp.makeConstraints { make in
                make.leading.equalTo(editorialsButton.snp.trailing).offset(Size.tabSpacing)
                make.top.equalTo(logoButton.snp.bottom).offset(Size.logoButtonMargin)
                make.height.equalTo(Size.buttonHeight)
                make.width.equalTo(otherButton)
            }
            middleLine.snp.makeConstraints { make in
                make.leading.trailing.bottom.equalTo(middleButton)
                make.height.equalTo(Size.lineThickness)
            }
        }

        otherButton.snp.makeConstraints { make in
            make.trailing.equalTo(navigationBar).inset(Size.margins)
            make.top.equalTo(logoButton.snp.bottom).offset(Size.logoButtonMargin)
            make.height.equalTo(Size.buttonHeight)

            if type.tabCount == 2 {
                make.leading.equalTo(editorialsButton.snp.trailing).offset(Size.tabSpacing)
            }
            else {
                make.leading.equalTo(middleButton.snp.trailing).offset(Size.tabSpacing)
            }
        }
        otherLine.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(otherButton)
            make.height.equalTo(Size.lineThickness)
        }
    }
}
