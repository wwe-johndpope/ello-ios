////
///  CategoryScreen.swift
//

public class CategoryScreen: StreamableScreen, CategoryScreenProtocol {

    struct Size {
        static let textInset: CGFloat = 15
    }

    weak var delegate: CategoryScreenDelegate?

    var category: Category?

    public init(category: Category) {
        self.category = category
        super.init(frame: UIScreen.mainScreen().bounds)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public required init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func style() {
        backgroundColor = .whiteColor()
    }

    override func bindActions() {
    }

    override func setText() {
    }

    override func arrange() {
        super.arrange()
        addSubview(navigationBar)
    }
}
