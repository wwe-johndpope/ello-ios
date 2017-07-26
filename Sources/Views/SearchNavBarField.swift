////
///  SearchNavBarField.swift
//

class SearchNavBarField: UITextField {
    struct Size {
        static let cornerRadius: CGFloat = 5
        static let leftViewCorrection = CGPoint(x: 10, y: 0.5)
        static let textCorrection = CGPoint(x: 4.5, y: 2)
        static let largeNavSearchInsets = UIEdgeInsets(top: 27, left: 15, bottom: 7, right: 7)
        static let searchInsets = UIEdgeInsets(top: 27, left: 7, bottom: 7, right: 7)
    }

    override required init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }

    fileprivate func sharedInit() {
        font = .defaultFont()
        backgroundColor = .greyE5
        clipsToBounds = true
        layer.cornerRadius = Size.cornerRadius
        clearButtonMode = .whileEditing
        textColor = .black
        autocapitalizationType = .none
        autocorrectionType = .no
        spellCheckingType = .no
        enablesReturnKeyAutomatically = true
        returnKeyType = .search
        keyboardAppearance = .dark
        keyboardType = .default

        attributedPlaceholder = NSAttributedString(
            string: InterfaceString.Search.Prompt,
            attributes: [
                NSForegroundColorAttributeName: UIColor.greyA
            ])

        leftViewMode = .always
        leftView = UIImageView(image: InterfaceImage.searchField.normalImage)
    }

    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += Size.leftViewCorrection.x
        rect.origin.y += Size.leftViewCorrection.y
        return rect
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return rectForBounds(bounds)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return rectForBounds(bounds)
    }

    fileprivate func rectForBounds(_ bounds: CGRect) -> CGRect {
        var rect = super.editingRect(forBounds: bounds)
        rect = rect.shrink(right: Size.textCorrection.x)
        rect = rect.shrink(down: Size.textCorrection.y)
        return rect
    }
}
