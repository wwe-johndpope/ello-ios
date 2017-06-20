////
///  ElloNavigationBar.swift
//

class ElloNavigationBar: UINavigationBar {
    struct Size {
        static let height: CGFloat = 64
        static let largeHeight: CGFloat = 110
    }

    enum SizeClass {
        case `default`
        case large

        var height: CGFloat {
            switch self {
            case .default: return Size.height
            case .large: return Size.largeHeight
            }
        }
    }

    var sizeClass: SizeClass = .default {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

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
        self.tintColor = UIColor.greyA()
        self.clipsToBounds = true
        self.shadowImage = UIImage.imageWithColor(UIColor.white)
        self.backgroundColor = UIColor.white
        self.isTranslucent = false
        self.isOpaque = true
        self.barTintColor = UIColor.white

        let bar = BlackBar(frame: CGRect(x: 0, y: 0, width: frame.width, height: 20))
        addSubview(bar)
    }

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height = sizeClass.height
        return size
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if sizeClass == .large {
            let leftItemViews = subviews.filter {
                return $0.frame.minX < frame.width / 2 && $0.frame.width < 60
            }
            let rightItemViews = subviews.filter {
                return $0.frame.minX > frame.width / 2 && $0.frame.width < 60
            }
            for view in leftItemViews + rightItemViews {
                view.frame.origin.y -= Size.largeHeight - Size.height
            }
        }

        if let navItem = topItem,
            let items = navItem.rightBarButtonItems
        {
            let views = items.flatMap { $0.customView }.sorted { $0.frame.maxX > $1.frame.maxX }
            var x: CGFloat = frame.width - 5.5
            let width: CGFloat = 39

            for view in views {
                x -= width
                view.frame = CGRect(
                    x: x,
                    y: view.frame.y,
                    width: width,
                    height: view.frame.height
                    )
            }
        }
    }

}
