////
///  PersistentBackButton.swift
//

class PersistentBackButton: Button {
    struct Size {
        static let height: CGFloat = 44
        static let margin: CGFloat = 5
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: Size.height, height: Size.height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(frame.width, frame.height) / 2
    }

    override func style() {
        super.style()

        backgroundColor = .white
        setImages(.back)
        layer.masksToBounds = true
        contentEdgeInsets = UIEdgeInsets(right: 2)
    }
}
