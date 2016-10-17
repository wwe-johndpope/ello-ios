////
///  ProfileCategoriesScreen.swift
//

import SnapKit


public class ProfileCategoriesScreen: UIView {

    struct Size {
        static let textInset: CGFloat = 15
    }

    weak var delegate: ProfileCategoriesDelegate?

    public let background = UIView()
    let textView = ElloTextView()
    var categories = [Category]()

    public init(categories: [Category]) {
        super.init(frame: .zero)
        self.categories = categories

        style()
        bindActions()
        setText()
        arrange()

        // for controllers that use "container" views, they need to be set to the correct dimensions,
        // otherwise there'll be constraint violations.
        layoutIfNeeded()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension ProfileCategoriesScreen {

    func style() {
        background.backgroundColor = .modalBackground()
        textView.backgroundColor = .clearColor()
        textView.editable = false
        textView.allowsEditingTextAttributes = false
        textView.selectable = false
        textView.textColor = .whiteColor()
    }

    func bindActions() {
        textView.textViewDelegate = self
    }

    func setText() {
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
            featuredIn = featuredIn.append(styleCatgory(category))
        }

        textView.attributedText = featuredIn
        textView.sizeToFit()
        layoutIfNeeded()
    }

    func arrange() {

        addSubview(background)
        addSubview(textView)

        background.snp_makeConstraints { make in
            make.edges.equalTo(self)
        }

        textView.snp_makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(Size.textInset)
            make.centerX.centerY.equalTo(self)
        }

        layoutIfNeeded()
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
        // no-opp
    }
}

private extension ProfileCategoriesScreen {

    func styleCatgory(category: Category) -> NSAttributedString {
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
