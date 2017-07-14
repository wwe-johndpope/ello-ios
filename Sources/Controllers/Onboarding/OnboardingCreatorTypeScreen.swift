////
///  OnboardingCreatorTypeScreen.swift
//

import SnapKit


class OnboardingCreatorTypeScreen: Screen {
    struct Size {
        static let margins: CGFloat = 15
        static let bigTop: CGFloat = 243
        static let smallTop: CGFloat = 15
        static let containerOffset: CGFloat = 60
        static let buttonOffset: CGFloat = 22
        static let buttonHeight: CGFloat = 50
    }
    weak var delegate: OnboardingCreatorTypeDelegate?

    fileprivate let scrollableContainer = UIScrollView()
    fileprivate let scrollableWidth = UIView()
    fileprivate let creatorTypeContainer = UIView()
    fileprivate let hereAsLabel = StyledLabel(style: .gray)
    fileprivate let artistButton = StyledButton(style: .roundedGrayOutline)
    fileprivate let fanButton = StyledButton(style: .roundedGrayOutline)
    fileprivate var scrollableContainerWidth: Constraint!
    fileprivate var creatorTypeContainerTop: Constraint!

    fileprivate let creatorLabel = StyledLabel(style: .gray)
    fileprivate let creatorButtonsContainer = UIView()
    fileprivate var creatorButtons: [UIView] = []

    override func style() {
        creatorButtonsContainer.alpha = 0
    }

    override func bindActions() {
        artistButton.addTarget(self, action: #selector(toggleCreatorType(sender:)), for: .touchUpInside)
        fanButton.addTarget(self, action: #selector(toggleCreatorType(sender:)), for: .touchUpInside)
    }

    override func setText() {
        creatorLabel.text = InterfaceString.Onboard.Interests
        hereAsLabel.text = InterfaceString.Onboard.HereAs
        artistButton.setTitle(InterfaceString.Onboard.Artist, for: .normal)
        fanButton.setTitle(InterfaceString.Onboard.Fan, for: .normal)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        scrollableContainerWidth.update(offset: frame.width)
    }

    override func arrange() {
        super.arrange()

        addSubview(scrollableContainer)

        scrollableContainer.addSubview(creatorTypeContainer)
        scrollableContainer.addSubview(scrollableWidth)

        creatorTypeContainer.addSubview(hereAsLabel)
        creatorTypeContainer.addSubview(artistButton)
        creatorTypeContainer.addSubview(fanButton)

        scrollableContainer.addSubview(creatorButtonsContainer)
        creatorButtonsContainer.addSubview(creatorLabel)

        scrollableContainer.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }

        scrollableWidth.snp.makeConstraints { make in
            scrollableContainerWidth = make.width.equalTo(frame.width).constraint
            make.leading.trailing.equalTo(scrollableContainer)
        }

        creatorTypeContainer.snp.makeConstraints { make in
            creatorTypeContainerTop = make.top.equalTo(scrollableContainer).offset(Size.bigTop).constraint
            make.leading.trailing.equalTo(scrollableContainer).inset(Size.margins)
        }

        creatorButtonsContainer.snp.makeConstraints { make in
            make.top.equalTo(creatorTypeContainer.snp.bottom).offset(Size.containerOffset)
            make.leading.trailing.equalTo(creatorTypeContainer)
            make.bottom.equalTo(scrollableContainer)
        }
        creatorLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(creatorButtonsContainer)
        }

        hereAsLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(creatorTypeContainer)
        }

        artistButton.snp.makeConstraints { make in
            make.leading.equalTo(creatorTypeContainer)
            make.width.equalTo(fanButton)
            make.top.equalTo(hereAsLabel.snp.bottom).offset(Size.buttonOffset)
            make.bottom.equalTo(creatorTypeContainer)
            make.height.equalTo(Size.buttonHeight)
        }

        fanButton.snp.makeConstraints { make in
            make.trailing.equalTo(creatorTypeContainer)
            make.leading.equalTo(artistButton.snp.trailing).offset(Size.margins)
            make.top.equalTo(hereAsLabel.snp.bottom).offset(Size.buttonOffset)
            make.bottom.equalTo(creatorTypeContainer)
            make.height.equalTo(Size.buttonHeight)
        }

        layoutCreatorSpinner()
        layoutCreatorCategories(["Woolen Earplugs", "Sawdust", "Boogers"])
    }

    fileprivate func layoutCreatorSpinner() {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        creatorButtonsContainer.addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.top.equalTo(creatorLabel.snp.bottom).offset(Size.buttonOffset)
            make.centerX.bottom.equalTo(creatorButtonsContainer)
        }
        creatorButtons = [spinner]
    }

    fileprivate func layoutCreatorCategories(_ creatorCategories: [String]) {
        for view in creatorButtons {
            view.removeFromSuperview()
        }

        creatorButtons = []
        var pairs: [[UIView]] = []
        var row: [UIView] = []
        var firstView: UIView?
        var prevRow: UIView?
        var prevView: UIView?
        for category in creatorCategories {
            let categoryView = StyledButton(style: .roundedGrayOutline)
            categoryView.titleLabel?.lineBreakMode = .byTruncatingTail
            categoryView.addTarget(self, action: #selector(toggleCreatorCategory(sender:)), for: .touchUpInside)
            creatorButtons.append(categoryView)
            categoryView.setTitle(category, for: .normal)
            creatorButtonsContainer.addSubview(categoryView)

            categoryView.snp.makeConstraints { make in
                if let prevRow = prevRow {
                    make.top.equalTo(prevRow.snp.bottom).offset(Size.margins)
                }
                else {
                    make.top.equalTo(creatorLabel.snp.bottom).offset(Size.buttonOffset)
                }

                switch row.count {
                case 0:
                    make.leading.equalTo(creatorButtonsContainer)
                case 1:
                    if let prevView = prevView {
                        make.leading.equalTo(prevView.snp.trailing).offset(Size.margins)
                    }
                    make.trailing.equalTo(creatorButtonsContainer)
                default:
                    break
                }

                if let firstView = firstView {
                    make.width.equalTo(firstView)
                }

                if category == creatorCategories.last {
                    make.bottom.equalTo(creatorButtonsContainer)
                }
                make.height.equalTo(Size.buttonHeight)
            }
            row.append(categoryView)

            if row.count == 2 || category == creatorCategories.last {
                prevRow = categoryView
                pairs.append(row)
                row = []
            }

            firstView = firstView ?? categoryView
            prevView = categoryView
        }
    }

    @objc
    func toggleCreatorCategory(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }

    @objc
    func toggleCreatorType(sender: UIButton) {
        if sender == fanButton {
            fanButton.isSelected = !fanButton.isSelected
            artistButton.isSelected = false
        }
        else {
            fanButton.isSelected = false
            artistButton.isSelected = !artistButton.isSelected
        }

        let creatorTypeY: CGFloat
        let creatorButtonsAlpha: CGFloat
        if artistButton.isSelected {
            creatorTypeY = Size.smallTop
            creatorButtonsAlpha = 1
        }
        else {
            creatorTypeY = Size.bigTop
            creatorButtonsAlpha = 0
        }
        creatorTypeContainerTop.update(offset: creatorTypeY)
        animate {
            self.creatorTypeContainer.frame.origin.y = creatorTypeY
            self.creatorButtonsContainer.frame.origin.y = creatorTypeY + self.creatorTypeContainer.frame.height + Size.containerOffset
            self.creatorButtonsContainer.alpha = creatorButtonsAlpha
        }
    }
}

extension OnboardingCreatorTypeScreen: OnboardingCreatorTypeScreenProtocol {
}
