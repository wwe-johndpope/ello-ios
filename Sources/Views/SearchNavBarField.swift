////
///  SearchNavBarField.swift
//

class SearchNavBarField: UITextField {
    struct Size {
        static let cornerRadius: CGFloat = 5
        static let verticalCorrection: CGFloat = 3
        static let searchInsets = UIEdgeInsets(top: 30, left: 10, bottom: 10, right: 5)
    }

    override var placeholder: String? {
        didSet {
            if let placeholder = placeholder {
                attributedPlaceholder = NSAttributedString(
                    string: placeholder,
                    attributes: [
                        NSForegroundColorAttributeName: UIColor.greyA()
                    ])
            }
        }
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
        font = .defaultFont(12)
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

        leftViewMode = .always
        leftView = UIImageView(image: InterfaceImage.searchSmall.normalImage)
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
