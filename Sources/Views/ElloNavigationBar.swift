////
///  ElloNavigationBar.swift
//

import SnapKit


@objc protocol HasBackButton { func backButtonTapped() }
@objc protocol HasCloseButton { func closeButtonTapped() }
@objc protocol HasDeleteButton { func deleteButtonTapped() }
@objc protocol HasEditButton { func editButtonTapped() }
@objc protocol HasGridListButton { func gridListToggled(_ sender: UIButton) }
@objc protocol HasHamburgerButton { func hamburgerButtonTapped() }
@objc protocol HasMoreButton { func moreButtonTapped() }
@objc protocol HasShareButton { func shareButtonTapped(_ sender: UIView) }

class ElloNavigationBar: UIView {
    struct Size {
        static let height: CGFloat = calculateHeight()
        static let largeHeight: CGFloat = calculateLargeHeight()
        static let discoverLargeHeight: CGFloat = 162
        static let navigationHeight: CGFloat = 44
        static let buttonWidth: CGFloat = 39

        static private func calculateHeight() -> CGFloat {
            return Size.navigationHeight + BlackBar.Size.height
        }
        static private func calculateLargeHeight() -> CGFloat {
            return 105 + BlackBar.Size.height
        }
    }

    enum SizeClass {
        case `default`
        case large
        case discoverLarge

        var height: CGFloat {
            switch self {
            case .default: return Size.height
            case .large: return Size.largeHeight
            case .discoverLarge: return Size.discoverLargeHeight
            }
        }
    }

    enum Item {
        case back
        case burger
        case close
        case edit
        case delete
        case gridList(isGrid: Bool)
        case more
        case share

        var firstInset: CGFloat {
            switch self {
            case .back: return -5
            default: return 0
            }
        }

        var lastInset: CGFloat {
            switch self {
            case .edit: return 1
            case .more: return -1.5
            default: return 0
            }
        }

        func generateButton(target: Any, action: Selector) -> UIButton {
            let button = UIButton()
            button.setImage(image, imageStyle: .normal, for: .normal)
            button.setImage(image, imageStyle: .selected, for: .selected)
            button.setImage(image, imageStyle: .disabled, for: .disabled)
            button.addTarget(target, action: action, for: .touchUpInside)
            return button
        }

        func trigger(from view: UIResponder, sender: UIButton) {
            switch self {
            case .back:
                let responder: HasBackButton? = view.findResponder()
                responder?.backButtonTapped()
            case .burger:
                let responder: HasHamburgerButton? = view.findResponder()
                responder?.hamburgerButtonTapped()
            case .close:
                let responder: HasCloseButton? = view.findResponder()
                responder?.closeButtonTapped()
            case .edit:
                let responder: HasEditButton? = view.findResponder()
                responder?.editButtonTapped()
            case .delete:
                let responder: HasDeleteButton? = view.findResponder()
                responder?.deleteButtonTapped()
            case .gridList:
                let responder: HasGridListButton? = view.findResponder()
                responder?.gridListToggled(sender)
            case .more:
                let responder: HasMoreButton? = view.findResponder()
                responder?.moreButtonTapped()
            case .share:
                let responder: HasShareButton? = view.findResponder()
                responder?.shareButtonTapped(sender)
            }
        }

        var image: InterfaceImage {
            switch self {
            case .back: return .back
            case .burger: return .burger
            case .close: return .x
            case .delete: return .xBox
            case .edit: return .pencil
            case let .gridList(isGrid): return isGrid ? .listView : .gridView
            case .more: return .dots
            case .share: return .share
            }
        }
    }

    var sizeClass: SizeClass = .default {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    var title: String? {
        didSet { titleLabel.text = title }
    }
    fileprivate var defaultTitle: String? {
        guard
            let controller: UIViewController = findResponder()
        else { return nil }
        return controller.title
    }
    fileprivate let titleLabel = StyledLabel(style: .gray)
    fileprivate let navigationContainer = Container()

    var leftItems: [Item] = [] {
        didSet { leftButtons = updateButtons(buttons: leftButtons, items: leftItems, container: leftButtonContainer) }
    }
    fileprivate var leftButtonContainer = Container()
    fileprivate var leftButtons: [UIButton] = []

    var rightItems: [Item] = [] {
        didSet { rightButtons = updateButtons(buttons: rightButtons, items: rightItems, container: rightButtonContainer) }
    }
    fileprivate var rightButtonContainer = Container()
    fileprivate var rightButtons: [UIButton] = []

    fileprivate var leftLeadingConstraint: Constraint!
    fileprivate var rightTrailingConstraint: Constraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        privateInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        privateInit()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        self.invalidateDefaultTitle()
    }

    func invalidateDefaultTitle() {
        titleLabel.text = title ?? defaultTitle
    }

    fileprivate func privateInit() {
        tintColor = .greyA
        clipsToBounds = true
        backgroundColor = .white
        isOpaque = true

        let bar = BlackBar()

        addSubview(titleLabel)
        addSubview(bar)
        addSubview(navigationContainer)
        navigationContainer.addSubview(leftButtonContainer)
        navigationContainer.addSubview(rightButtonContainer)

        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(navigationContainer)
        }

        bar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self)
        }

        navigationContainer.snp.makeConstraints { make in
            make.top.equalTo(bar.snp.bottom)
            make.height.equalTo(Size.navigationHeight)
            make.leading.trailing.equalTo(self)
        }

        leftButtonContainer.snp.makeConstraints { make in
            make.top.bottom.equalTo(navigationContainer)
            leftLeadingConstraint = make.leading.equalTo(navigationContainer).constraint
        }

        rightButtonContainer.snp.makeConstraints { make in
            make.top.bottom.equalTo(navigationContainer)
            rightTrailingConstraint = make.trailing.equalTo(navigationContainer).constraint
        }

    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: sizeClass.height)
    }

    fileprivate func updateButtons(buttons oldButtons: [UIButton], items: [Item], container: UIView) -> [UIButton] {
        for button in oldButtons {
            button.removeFromSuperview()
        }

        let newButtons = items.map { $0.generateButton(target: self, action: #selector(tappedButton(_:)))}
        newButtons.eachPair { prevButton, button, isLast in
            container.addSubview(button)

            button.snp.makeConstraints { make in
                make.top.bottom.equalTo(container)
                make.height.equalTo(Size.navigationHeight)
                make.width.equalTo(Size.buttonWidth)

                if let prevButton = prevButton {
                    make.leading.equalTo(prevButton.snp.trailing)
                }
                else {
                    make.leading.equalTo(container)
                }

                if isLast {
                    make.trailing.equalTo(container)
                }
            }
        }

        if container == leftButtonContainer {
            let leftInset = items.first?.firstInset ?? 0
            leftLeadingConstraint.update(offset: leftInset)
        }
        else {
            let rightInset = items.last?.lastInset ?? 0
            rightTrailingConstraint.update(offset: rightInset)
        }

        return newButtons
    }

    @objc
    private func tappedButton(_ sender: UIButton) {
        var item: Item?
        if let index = leftButtons.index(of: sender) {
            item = leftItems[index]
        }
        else if let index = rightButtons.index(of: sender) {
            item = rightItems[index]
        }

        item?.trigger(from: self, sender: sender)
    }

}
