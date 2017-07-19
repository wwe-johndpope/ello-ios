////
///  OnboardingCreatorTypeScreen.swift
//

import SnapKit


class OnboardingCreatorTypeScreen: StreamableScreen {
    struct Size {
        static let margins: CGFloat = 15
        static let bigTop: CGFloat = 243
        static let smallTop: CGFloat = 64
        static let containerOffset: CGFloat = 60
        static let buttonOffset: CGFloat = 22
        static let buttonHeight: CGFloat = 50
    }

    enum CreatorType {
        case none
        case fan
        case artist([Int])
    }

    weak var delegate: OnboardingCreatorTypeDelegate?
    var creatorCategories: [String] = [] {
        didSet {
            updateCreatorCategories()
        }
    }

    fileprivate let scrollableContainer = UIScrollView()
    fileprivate let scrollableWidth = UIView()
    fileprivate let creatorTypeContainer = UIView()
    fileprivate let hereAsLabel = StyledLabel(style: .gray)
    fileprivate let artistButton = StyledButton(style: .roundedGrayOutline)
    fileprivate let fanButton = StyledButton(style: .roundedGrayOutline)
    fileprivate var scrollableContainerWidth: Constraint!
    fileprivate var scrollableContainerFanBottom: Constraint!
    fileprivate var scrollableContainerArtistBottom: Constraint!
    fileprivate var creatorTypeContainerTop: Constraint!
    fileprivate let creatorLabel = StyledLabel(style: .gray)
    fileprivate let creatorButtonsContainer = UIView()
    fileprivate var creatorButtons: [UIView] = []

    override func style() {
        super.style()
        creatorButtonsContainer.alpha = 0
    }

    override func bindActions() {
        super.bindActions()
        artistButton.addTarget(self, action: #selector(toggleCreatorType(sender:)), for: .touchUpInside)
        fanButton.addTarget(self, action: #selector(toggleCreatorType(sender:)), for: .touchUpInside)
    }

    override func setText() {
        super.setText()
        hereAsLabel.text = InterfaceString.Onboard.HereAs
        artistButton.setTitle(InterfaceString.Onboard.Artist, for: .normal)
        fanButton.setTitle(InterfaceString.Onboard.Fan, for: .normal)
        creatorLabel.text = InterfaceString.Onboard.Interests
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        scrollableContainerWidth?.update(offset: frame.width)
    }

    override func arrange() {
        super.arrange()

        addSubview(scrollableContainer)
        addSubview(navigationBar)

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
            scrollableContainerFanBottom = make.bottom.equalTo(scrollableContainer).inset(Size.margins).constraint
        }

        creatorLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(creatorButtonsContainer)
        }

        creatorButtonsContainer.snp.makeConstraints { make in
            make.top.equalTo(creatorTypeContainer.snp.bottom).offset(Size.containerOffset)
            make.leading.trailing.equalTo(creatorTypeContainer)
            scrollableContainerArtistBottom = make.bottom.equalTo(scrollableContainer).offset(-Size.margins).constraint
        }

        scrollableContainerArtistBottom.deactivate()
        scrollableContainerFanBottom.activate()

        addCreatorCategoriesSpinner()
    }

    fileprivate func addCreatorCategoriesSpinner() {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        creatorButtonsContainer.addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.top.equalTo(creatorLabel.snp.bottom).offset(Size.buttonOffset)
            make.centerX.bottom.equalTo(creatorButtonsContainer)
        }
        creatorButtons = [spinner]
    }

    fileprivate func updateCreatorCategories() {
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
            categoryView.addTarget(self, action: #selector(toggleCreatorCategory(sender:)), for: .touchUpInside)
            creatorButtons.append(categoryView)
            categoryView.title = category
            categoryView.titleLineBreakMode = .byTruncatingTail
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

                if creatorCategories.count == 1 {
                    let width = (UIScreen.main.bounds.width - 3 * Size.margins) / 2
                    make.width.equalTo(width)
                }
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

        var paths: [Int] = []
        for (index, view) in creatorButtons.enumerated() {
            if let button = view as? UIButton, button.isSelected {
                paths.append(index)
            }
        }
        delegate?.creatorTypeChanged(type: .artist(paths))
    }

    @objc
    func toggleCreatorType(sender: UIButton) {
        let isSelected = !sender.isSelected
        let type: CreatorType
        if isSelected {
            if sender == fanButton {
                type = .fan
            }
            else {
                type = .artist([])
            }
        }
        else {
            type = .none
        }

        delegate?.creatorTypeChanged(type: type)
        updateButtons(type: type)
    }

    func updateButtons(type: CreatorType, animated: Bool = true) {
        switch type {
        case .none:
            fanButton.isSelected = false
            artistButton.isSelected = false
            scrollableContainerArtistBottom.deactivate()
            scrollableContainerFanBottom.activate()
        case .fan:
            fanButton.isSelected = true
            artistButton.isSelected = false
            scrollableContainerArtistBottom.deactivate()
            scrollableContainerFanBottom.activate()
        case .artist:
            fanButton.isSelected = false
            artistButton.isSelected = true
            scrollableContainerArtistBottom.activate()
            scrollableContainerFanBottom.deactivate()
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

        let completion: (Bool) -> Void = { _ in
            self.unselectAllCategories()
        }
        animate(animated: animated, completion: completion) {
            self.creatorTypeContainer.frame.origin.y = creatorTypeY
            self.creatorButtonsContainer.frame.origin.y = creatorTypeY + self.creatorTypeContainer.frame.height + Size.containerOffset
            self.creatorButtonsContainer.alpha = creatorButtonsAlpha
        }
    }

    func unselectAllCategories() {
        creatorButtons.flatMap({ (button: UIView) -> UIButton? in return button as? UIButton }).forEach { button in
            button.isSelected = false
        }
    }
}

extension OnboardingCreatorTypeScreen: OnboardingCreatorTypeScreenProtocol {

    func updateCreatorType(type: Profile.CreatorType) {
        switch type {
        case .none:
            updateButtons(type: .none, animated: false)
            unselectAllCategories()
        case .fan:
            updateButtons(type: .fan, animated: false)
            unselectAllCategories()
        case let .artist(categories):
            updateButtons(type: .artist([]), animated: false)
            creatorButtons.flatMap({ (button: UIView) -> UIButton? in return button as? UIButton }).forEach { button in
                button.isSelected = categories.any({ button.title(for: .normal) == $0.name })
            }
        }
    }

}
