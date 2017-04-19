////
///  SearchNavBarField.swift
//

class SearchNavBarField: UITextField {
    struct Size {
        static let cornerRadius: CGFloat = 5
        static let verticalCorrection: CGFloat = 3
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
        backgroundColor = .greyE5()
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
                NSForegroundColorAttributeName: UIColor.greyA()
            ])

        leftViewMode = .always
        leftView = UIImageView(image: InterfaceImage.searchField.normalImage)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return rectForBounds(bounds)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return rectForBounds(bounds)
    }

    fileprivate func rectForBounds(_ bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.shrink(down: Size.verticalCorrection)
    }
}
