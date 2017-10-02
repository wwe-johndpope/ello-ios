////
///  ElloNavigationBar.swift
//

class ElloNavigationBar: UIView {
    struct Size {
        static let height: CGFloat = calculateHeight()
        static let largeHeight: CGFloat = calculateLargeHeight()
        static let discoverLargeHeight: CGFloat = 162
        static let buttonWidth: CGFloat = 39

        static private func calculateHeight() -> CGFloat {
            return 44 + BlackBar.Size.height
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
        case gridList(isGrid: Bool)

        func generateButton(target: Any, action: Selector) -> UIButton {
            let frame = CGRect(x: 0, y: 0, width: 36.0, height: 44.0)
            let button = UIButton(frame: frame)
            button.setImage(image, imageStyle: .normal, for: .normal)
            button.setImage(image, imageStyle: .selected, for: .selected)
            button.setImage(image, imageStyle: .disabled, for: .disabled)
            button.addTarget(target, action: action, for: .touchUpInside)
            return button
        }

        func trigger(from view: UIResponder, sender: UIButton) {
            switch self {
            case .back:
                let responder: BaseElloViewController? = view.findResponder()
                responder.backTapped()
            case .burger:
                let responder: StreamableViewController? = view.findResponder()
                responder.hamburgerButtonTapped()
            case .gridList:
                let responder: GridListToggleDelegate? = view.findResponder()
                responder.gridListToggled(sender)
            }
        }

        var image: InterfaceImage {
            switch self {
            case .back: return .back
            case .burger: return .burger
            case .gridList(isGrid): return isGrid ? .listView : .gridView
            }
        }
    }

    var sizeClass: SizeClass = .default {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    var leftItems: [Item] = [] {
        didSet { leftButtons = updateButtons(buttons: leftButtons, items: leftItems, parent: leftButtonContainer) }
    }
    fileprivate var leftButtonContainer = UIView()
    fileprivate var leftButtons: [UIButton] = []

    var rightItems: [Item] = [] {
        didSet { rightButtons = updateButtons(buttons: rightButtons, items: rightItems, parent: rightButtonContainer) }
    }
    fileprivate var rightButtonContainer = UIView()
    fileprivate var rightButtons: [UIButton] = []

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

    fileprivate func privateInit() {
        tintColor = .greyA
        clipsToBounds = true
        backgroundColor = .white
        isOpaque = true

        let bar = BlackBar()
        addSubview(bar)
        addSubview(leftButtonContainer)
        addSubview(rightButtonContainer)

        bar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self)
        }

        leftButtonContainer.snp.makeConstraints { make in
            make.top.equalTo(bar.snp.bottom)
            make.leading.bottom.equalTo(self)
        }

        rightButtonContainer.snp.makeConstraints { make in
            make.top.equalTo(bar.snp.bottom)
            make.trailing.bottom.equalTo(self)
        }

    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: sizeClass.height)
    }

    fileprivate func updateButtons(buttons oldButtons: [UIButton], items: [Item], parent parentView: UIView) -> [UIButton] {
        for button in oldButtons {
            button.removeFromSuperview()
        }

        let newButtons = items.map { $0.generateButton(target: self, action: #selector(tappedButton(_:)))}
        newButtons.eachPair { prevButton, button, isLast in
            parentView.addSubview(button)

            button.snp.makeConstraints { make in
                make.top.bottom.equalTo(parentView)
                make.width.equalTo(Size.buttonWidth)

                if let prevButton = prevButton {
                    make.leading.equalTo(prevButton.snp.trailing)
                }
                else {
                    make.leading.equalTo(parentView)
                }

                if isLast {
                    make.trailing.equalTo(parentView)
                }
            }
        }
    }

    @objc
    private func tappedButton(_ sender: UIButton) {
        let item: Item?
        if let index = leftButtons.index(of: sender) {
            item = leftItems[index]
        }
        else if let index = rightButtons.index(of: sender) {
            item = rightItems[index]
        }

        item?.trigger(from: self, sender: sender)
    }

}
