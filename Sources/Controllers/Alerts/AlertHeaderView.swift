////
///  AlertHeaderView.swift
//

class AlertHeaderView: UIView {
    struct Size {
        static let topMargin: CGFloat = 6.5
    }
    var label = StyledLabel(style: .black)

    convenience init() {
        self.init(frame: .zero)
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)

        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        addSubview(label)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = self.bounds.shift(up: Size.topMargin)
    }

    override var intrinsicContentSize: CGSize {
        return label.intrinsicContentSize
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return label.sizeThatFits(size)
    }
}
