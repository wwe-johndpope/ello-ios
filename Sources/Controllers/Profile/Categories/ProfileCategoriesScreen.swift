////
///  ProfileCategoriesScreen.swift
//

import SnapKit


public class ProfileCategoriesScreen: Screen {

    struct Size {
        static let textInset: CGFloat = 15
    }

    weak var delegate: ProfileCategoriesDelegate?

    public let background = UIView()
    let textView = ElloTextView()
    var categories: [Category]

    public init(categories: [Category]) {
        self.categories = categories
        super.init(frame: .zero)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public required init(frame: CGRect) {
        self.categories = []
        super.init(frame: frame)
    }

    override func style() {
        backgroundColor = .clearColor()
        background.backgroundColor = .modalBackground()
        textView.backgroundColor = .clearColor()
        textView.editable = false
        textView.allowsEditingTextAttributes = false
        textView.selectable = false
        textView.textColor = .whiteColor()
    }

    override func bindActions() {
        textView.textViewDelegate = self
    }

    override func setText() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center

        var featuredIn = NSAttributedString(string: InterfaceString.Profile.FeaturedIn, attributes: attrs([
                NSParagraphStyleAttributeName: paragraphStyle
            ]))

        let count = categories.count
        for (index, category) in categories.enumerate() {
            let prefix: NSAttributedString
            if index == count - 1 && count > 1 {
                prefix = NSAttributedString(string: " & ", attributes: attrs())
            }
            else if index > 0 {
                prefix = NSAttributedString(string: ", ", attributes: attrs())
            }
            else {
                prefix = NSAttributedString(string: " ", attributes: attrs())
            }
            featuredIn = featuredIn.append(prefix)
            featuredIn = featuredIn.append(styleCategory(category))
        }

        textView.attributedText = featuredIn
        textView.sizeToFit()
    }

    override func arrange() {
        super.arrange()

        addSubview(background)
        addSubview(textView)

        background.snp_makeConstraints { make in
            make.edges.equalTo(self)
        }

        textView.snp_makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(Size.textInset)
            make.centerX.centerY.equalTo(self)
        }
    }
}

extension ProfileCategoriesScreen: ElloTextViewDelegate {

    func textViewTapped(link: String, object: ElloAttributedObject) {
        switch object {
        case let .AttributedCategory(category):
            delegate?.categoryTapped(category)
        default: break
        }
    }

    func textViewTappedDefault() {
        // no-op
    }
}

private extension ProfileCategoriesScreen {

    func styleCategory(category: Category) -> NSAttributedString {
        return NSAttributedString(string: category.name, attributes: attrs([
            ElloAttributedText.Link: "category",
            ElloAttributedText.Object: category,
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
        ]))
    }

    func attrs(addlAttrs: [String : AnyObject] = [:]) -> [String : AnyObject] {
        let attrs: [String: AnyObject] = [
            NSFontAttributeName: UIFont.defaultFont(18),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
        ]
        return attrs + addlAttrs
    }
}
