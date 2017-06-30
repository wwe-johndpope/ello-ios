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
}

struct HomeScreenNavBarSize {
    static let margins = UIEdgeInsets(top: 32, left: 15, bottom: 20, right: 15)
    static let typeOffset: CGFloat = 18.625
    static let buttonHeight: CGFloat = 40
    static let lineThickness: CGFloat = 1
}

fileprivate typealias Size = HomeScreenNavBarSize

enum HomeScreenType {
    case editorials
    case following
}

extension HomeScreenNavBar {

    func arrangeHomeScreenNavBar(type: HomeScreenType, navigationBar: UIView) {
        let logoButton = UIButton()
        navigationBar.addSubview(logoButton)
        logoButton.setImage(.elloType, imageStyle: .normal, for: .normal)
        logoButton.addTarget(self, action: #selector(homeScreenScrollToTop), for: .touchUpInside)

        let editorialsButton = StyledButton(style: type == .editorials ? .clearBlack : .clearGray)
        editorialsButton.setTitle(InterfaceString.Editorials.NavbarTitle, for: .normal)
        if type == .following {
            editorialsButton.addTarget(self, action: #selector(homeScreenEditorialsTapped), for: .touchUpInside)
        }
        navigationBar.addSubview(editorialsButton)

        let editorialsLine = UIView()
        editorialsLine.backgroundColor = type == .editorials ? .black : .greyA()
        editorialsButton.addSubview(editorialsLine)

        let followingButton = StyledButton(style: type == .following ? .clearBlack : .clearGray)
        followingButton.setTitle(InterfaceString.Following.Title, for: .normal)
        if type == .editorials {
            followingButton.addTarget(self, action: #selector(homeScreenFollowingTapped), for: .touchUpInside)
        }
        navigationBar.addSubview(followingButton)

        let followingLine = UIView()
        followingLine.backgroundColor = type == .following ? .black : .greyA()
        followingButton.addSubview(followingLine)

        logoButton.snp.makeConstraints { make in
            make.centerX.equalTo(navigationBar)
            make.top.equalTo(navigationBar).offset(BlackBar.Size.height + HomeScreenNavBarSize.typeOffset)
        }

        editorialsButton.snp.makeConstraints { make in
            make.leading.equalTo(navigationBar).inset(Size.margins)
            make.trailing.equalTo(followingButton.snp.leading).inset(Size.margins)
            make.bottom.equalTo(navigationBar).inset(Size.margins)
            make.height.equalTo(Size.buttonHeight)
            make.width.equalTo(followingButton)
        }
        editorialsLine.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(editorialsButton)
            make.height.equalTo(Size.lineThickness)
        }
        followingButton.snp.makeConstraints { make in
            make.trailing.equalTo(navigationBar).inset(Size.margins)
            make.bottom.equalTo(navigationBar).inset(Size.margins)
            make.height.equalTo(Size.buttonHeight)
        }
        followingLine.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(followingButton)
            make.height.equalTo(Size.lineThickness)
        }
    }
}
