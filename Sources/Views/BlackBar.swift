////
///  BlackBar.swift
//

class BlackBar: UIView {
    struct Size {
        static let height: CGFloat = 20
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        backgroundColor = .black
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: Size.height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame.size.height = Size.height
    }

}
