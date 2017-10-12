///
///  RevealControllerCell.swift
//

protocol RevealControllerResponder: class {
    func revealControllerTapped(info: Any)
}

class RevealControllerCell: CollectionViewCell {
    static let reuseIdentifier = "RevealControllerCell"
    struct Size {
        static let margin: CGFloat = 15
        static let height: CGFloat = 40
    }

    var text: String? {
        get { return label.text }
        set { label.text = newValue }
    }

    private let label = StyledLabel(style: .gray)
    private let arrow = UIImageView()

    override func style() {
        arrow.interfaceImage = .angleBracket
    }

    override func arrange() {
        contentView.addSubview(label)
        contentView.addSubview(arrow)

        label.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(Size.margin)
            make.centerY.equalTo(contentView)
        }

        arrow.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(Size.margin)
            make.centerY.equalTo(contentView)
        }
    }
}
