////
///  OnboardingScreen.swift
//

public class OnboardingScreen: EmptyScreen {
    public struct Size {
        static let buttonHeight: CGFloat = 50
        static let buttonInset: CGFloat = 10
        static let abortButtonWidth: CGFloat = 70
    }
    public var controllerContainer = UIView()
    private var buttonContainer = UIView()
    private var skipButton = StyledButton(style: .RoundedGray)
    private var nextButton = StyledButton(style: .Green)
    private var abortButton = StyledButton(style: .GrayText)

    public weak var delegate: OnboardingDelegate?

    public var canGoNext: Bool = false {
        didSet {
            skipButton.hidden = canGoNext
            nextButton.hidden = !canGoNext
            abortButton.hidden = !canGoNext
        }
    }
    public var prompt: String? {
        get { return skipButton.currentTitle }
        set { skipButton.setTitle(newValue ?? InterfaceString.Onboard.CreateProfile, forState: .Normal) }
    }

    override func style() {
        buttonContainer.backgroundColor = .greyE5()
        abortButton.hidden = true

        nextButton.hidden = true
    }

    override func bindActions() {
        skipButton.addTarget(self, action: #selector(skipAction), forControlEvents: .TouchUpInside)
        nextButton.addTarget(self, action: #selector(nextAction), forControlEvents: .TouchUpInside)
        abortButton.addTarget(self, action: #selector(abortAction), forControlEvents: .TouchUpInside)
    }

    override func setText() {
        skipButton.setTitle(InterfaceString.Onboard.CreateProfile, forState: .Normal)
        nextButton.setTitle(InterfaceString.Onboard.CreateProfile, forState: .Normal)
        abortButton.setTitle(InterfaceString.Onboard.ImDone, forState: .Normal)
    }

    override func arrange() {
        super.arrange()

        addSubview(controllerContainer)
        addSubview(buttonContainer)
        buttonContainer.addSubview(skipButton)
        buttonContainer.addSubview(nextButton)
        buttonContainer.addSubview(abortButton)

        buttonContainer.snp_makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self)
            make.top.equalTo(keyboardAnchor.snp_top).offset(-(2 * Size.buttonInset + Size.buttonHeight))
        }

        skipButton.snp_makeConstraints { make in
            make.top.leading.trailing.equalTo(buttonContainer).inset(Size.buttonInset)
            make.height.equalTo(Size.buttonHeight)
        }

        nextButton.snp_makeConstraints { make in
            make.top.bottom.leading.equalTo(skipButton)
        }

        abortButton.snp_makeConstraints { make in
            make.top.bottom.trailing.equalTo(skipButton)
            make.leading.equalTo(nextButton.snp_trailing).offset(Size.buttonInset)
            make.width.equalTo(Size.abortButtonWidth)
        }

        controllerContainer.snp_makeConstraints { make in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(blackBar.snp_bottom)
            make.bottom.equalTo(buttonContainer.snp_top)
        }
    }

    public func styleFor(step step: OnboardingStep) {
        let nextString: String
        switch step {
        case .Categories: nextString = InterfaceString.Onboard.CreateProfile
        case .CreateProfile: nextString = InterfaceString.Onboard.InvitePeople
        case .InviteFriends: nextString = InterfaceString.Join.Discover
        }

        skipButton.hidden = false
        nextButton.hidden = true
        abortButton.hidden = true
        skipButton.setTitle(nextString, forState: .Normal)
        nextButton.setTitle(nextString, forState: .Normal)
    }
}

extension OnboardingScreen {
    func skipAction() {
        delegate?.skipAction()
    }

    func nextAction() {
        delegate?.nextAction()
    }

    func abortAction() {
        delegate?.abortAction()
    }
}

extension OnboardingScreen: OnboardingScreenProtocol {}
