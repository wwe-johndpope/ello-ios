////
///  BlackBar.swift
//

class BlackBar: View {
    struct Size {
        static let height: CGFloat = 20
    }

    override func style() {
        autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        backgroundColor = .black
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: Size.height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame.size.height = Size.height
    }

}
