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
    func homeScreenEditorialsTapped()
    func homeScreenFollowingTapped()
}

struct HomeScreenNavBarSize {
    static let margins = UIEdgeInsets(top: 40, left: 15, bottom: 28, right: 15)
    static let lineThickness: CGFloat = 2
    static let lineMargin: CGFloat = 10
}

fileprivate typealias Size = HomeScreenNavBarSize

enum HomeScreenType {
    case editorials
    case following
}

extension HomeScreenNavBar {

    func arrangeHomeScreenNavBar(type: HomeScreenType, navigationBar: UIView) {
        let editorialsButton = StyledButton(style: type == .editorials ? .clearBlack : .clearGray)
        editorialsButton.setTitle(InterfaceString.Editorials.Title, for: .normal)
        navigationBar.addSubview(editorialsButton)
        if type == .following {
            // editorialsButton.addTarget(self, action: #selector(homeScreenEditorialsTapped), for: .touchUpInside)
        }

        let editorialsLine = UIView()
        editorialsLine.backgroundColor = type == .editorials ? .black : .greyA()
        navigationBar.addSubview(editorialsLine)

        let followingButton = StyledButton(style: type == .following ? .clearBlack : .clearGray)
        followingButton.setTitle(InterfaceString.Following.Title, for: .normal)
        navigationBar.addSubview(followingButton)
        if type == .editorials {
            // followingButton.addTarget(self, action: #selector(homeScreenFollowingTapped), for: .touchUpInside)
        }

        let followingLine = UIView()
        followingLine.backgroundColor = type == .following ? .black : .greyA()
        navigationBar.addSubview(followingLine)

        editorialsButton.snp.makeConstraints { make in
            make.leading.equalTo(navigationBar).inset(Size.margins)
            make.trailing.equalTo(followingButton.snp.leading).inset(Size.margins)
            make.bottom.equalTo(editorialsLine.snp.top).offset(-Size.lineMargin)
            make.width.equalTo(followingButton)
        }
        editorialsLine.snp.makeConstraints { make in
            make.leading.trailing.equalTo(editorialsButton)
            make.bottom.equalTo(navigationBar).inset(Size.margins)
            make.height.equalTo(Size.lineThickness)
        }
        followingButton.snp.makeConstraints { make in
            make.trailing.equalTo(navigationBar).inset(Size.margins)
            make.bottom.equalTo(followingLine.snp.top).offset(-Size.lineMargin)
        }
        followingLine.snp.makeConstraints { make in
            make.leading.trailing.equalTo(followingButton)
            make.bottom.equalTo(navigationBar).inset(Size.margins)
            make.height.equalTo(Size.lineThickness)
        }
    }
}
