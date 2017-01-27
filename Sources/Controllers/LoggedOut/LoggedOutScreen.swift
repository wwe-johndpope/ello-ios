////
///  LoggedOutScreen.swift
//

import SnapKit


class LoggedOutScreen: Screen, LoggedOutScreenProtocol {
    struct Size {
        static let bottomBarHeight: CGFloat = 70
        static let buttonInset: CGFloat = 10
        static let loginButtonWidth: CGFloat = 75
    }

    let controllerView = UIView()
    let bottomBarView = UIView()
    let joinButton = StyledButton(style: .Green)
    let loginButton = StyledButton(style: .LightGray)
    weak var delegate: LoggedOutProtocol?

    var bottomBarTopConstraint: Constraint!
    var bottomBarCollapsedConstraint: Constraint!
    var bottomBarExpandedConstraint: Constraint!

    var bottomBarHeight: CGFloat {
        if bottomBarView.frame.minY < frame.height {
            return Size.bottomBarHeight
        }
        return 0
    }

    func setControllerView(_ childView: UIView) {
        for view in controllerView.subviews {
            view.removeFromSuperview()
        }

        controllerView.addSubview(childView)
    }

    override func bindActions() {
        joinButton.addTarget(self, action: #selector(joinAction), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
    }

    override func style() {
        bottomBarView.backgroundColor = .greyE5()
        joinButton.setTitle(InterfaceString.Startup.SignUp, for: .normal)
        loginButton.setTitle(InterfaceString.Startup.Login, for: .normal)
    }

    override func arrange() {
        super.arrange()

        addSubview(controllerView)
        addSubview(bottomBarView)
        bottomBarView.addSubview(loginButton)
        bottomBarView.addSubview(joinButton)

        controllerView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }

        bottomBarView.snp.makeConstraints { make in
            make.trailing.leading.equalTo(self)
            bottomBarCollapsedConstraint = make.height.equalTo(Size.bottomBarHeight).constraint
            bottomBarTopConstraint = make.bottom.equalTo(self).constraint
            // bottomBarExpandedConstraint
        }

        joinButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalTo(bottomBarView).inset(Size.buttonInset)
        }

        loginButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalTo(bottomBarView).inset(Size.buttonInset)
            make.leading.equalTo(joinButton.snp.trailing).offset(Size.buttonInset)
            make.width.equalTo(Size.loginButtonWidth)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        for childView in controllerView.subviews {
            childView.frame = controllerView.bounds
        }
    }
}

extension LoggedOutScreen {
    @objc
    func joinAction() {
        delegate?.showJoinScreen()
    }

    @objc
    func loginAction() {
        delegate?.showLoginScreen()
    }
}
