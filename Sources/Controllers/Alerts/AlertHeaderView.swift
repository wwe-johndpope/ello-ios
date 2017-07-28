////
///  AlertHeaderView.swift
//

class AlertHeaderView: UIView {
    struct Size {
        static let topMargin: CGFloat = 0.5
    }
    var label = StyledLabel(style: .black)

    convenience init() {
        self.init(frame: .zero)
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)

        label.isMultiline = true
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
