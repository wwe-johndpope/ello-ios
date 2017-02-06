////
///  LoggedOutScreen.swift
//

import SnapKit


class LoggedOutScreen: Screen, LoggedOutScreenProtocol {
    struct Size {
        static let bottomBarHeight: CGFloat = 70
        static let buttonInset: CGFloat = 10
        static let loginButtonWidth: CGFloat = 75
        static let closeButtonOffset = CGPoint(x: 6, y: -5)
    }

    let controllerView = UIView()
    let bottomBarView = UIView()
    let joinButton = StyledButton(style: .Green)
    let loginButton = StyledButton(style: .LightGray)
    let closeButton = UIButton()
    let joinLabel = StyledLabel(style: .Large)
    let tagLabel = StyledLabel(style: .Black)
    weak var delegate: LoggedOutProtocol?

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

    override func setText() {
        joinLabel.text = InterfaceString.Startup.Join
        tagLabel.text = InterfaceString.Startup.Tagline
    }

    override func bindActions() {
        joinButton.addTarget(self, action: #selector(joinAction), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(hideJoinText), for: .touchUpInside)
    }

    override func style() {
        closeButton.setImages(.x)
        tagLabel.numberOfLines = 0
        bottomBarView.backgroundColor = .greyEF()
        bottomBarView.clipsToBounds = true
        joinButton.setTitle(InterfaceString.Startup.SignUp, for: .normal)
        loginButton.setTitle(InterfaceString.Startup.Login, for: .normal)
    }

    override func arrange() {
        super.arrange()

        addSubview(controllerView)
        addSubview(bottomBarView)
        bottomBarView.addSubview(loginButton)
        bottomBarView.addSubview(joinLabel)
        bottomBarView.addSubview(tagLabel)
        bottomBarView.addSubview(joinButton)
        bottomBarView.addSubview(closeButton)

        controllerView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }

        bottomBarView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalTo(self)
            bottomBarCollapsedConstraint = make.height.equalTo(Size.bottomBarHeight).constraint
            bottomBarExpandedConstraint = make.top.equalTo(joinLabel.snp.top).offset(-20).constraint
        }
        bottomBarExpandedConstraint.deactivate()

        tagLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(bottomBarView).inset(Size.buttonInset)
            make.bottom.equalTo(joinButton.snp.top).offset(-20)
        }

        joinLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(bottomBarView).inset(Size.buttonInset)
            make.bottom.equalTo(tagLabel.snp.top).offset(-20)
        }

        joinButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(bottomBarView).inset(Size.buttonInset)
            make.height.equalTo(Size.bottomBarHeight - 2 * Size.buttonInset)
        }

        loginButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(bottomBarView).inset(Size.buttonInset)
            make.height.equalTo(Size.bottomBarHeight - 2 * Size.buttonInset)
            make.leading.equalTo(joinButton.snp.trailing).offset(Size.buttonInset)
            make.width.equalTo(Size.loginButtonWidth)
        }

        closeButton.snp.makeConstraints { make in
            make.trailing.equalTo(bottomBarView).inset(Size.buttonInset + Size.closeButtonOffset.x)
            make.top.equalTo(joinLabel).offset(Size.closeButtonOffset.y)
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
    func showJoinText() {
        bottomBarCollapsedConstraint.deactivate()
        bottomBarExpandedConstraint.activate()
        animate {
            self.layoutIfNeeded()
        }
    }

    @objc
    func joinAction() {
        delegate?.showJoinScreen()
    }

    @objc
    func loginAction() {
        delegate?.showLoginScreen()
    }

    @objc
    func hideJoinText() {
        bottomBarCollapsedConstraint.activate()
        bottomBarExpandedConstraint.deactivate()
        animate {
            self.layoutIfNeeded()
        }
    }
}
