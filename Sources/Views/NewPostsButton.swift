////
///  NewPostsButton.swift
//

import SnapKit


class NewPostsButton: UIControl {
    struct Size {
        static let top: CGFloat = 45
        static let sideMargin: CGFloat = 15
        static let innerMargin: CGFloat = 7
        static let height: CGFloat = 35
    }

    let bg = UIImageView()
    let arrow = UIImageView()
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setText()
        style()
        arrange()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setText() {
        arrow.setInterfaceImage(.arrow, style: .white)
        label.text = InterfaceString.Following.NewPosts
    }

    private func style() {
        label.font = .defaultFont(16)
        label.textColor = .white
        bg.alpha = 0.8
        bg.backgroundColor = .black
        bg.clipsToBounds = true
    }

    private func arrange() {
        addSubview(bg)
        addSubview(arrow)
        addSubview(label)

        bg.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }

        arrow.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self.snp.leading).offset(Size.sideMargin)
        }

        label.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(arrow.snp.trailing).offset(Size.innerMargin)
        }
    }

    override var intrinsicContentSize: CGSize {
        guard
            arrow.intrinsicContentSize.width != UIViewNoIntrinsicMetric,
            label.intrinsicContentSize.width != UIViewNoIntrinsicMetric
        else { return super.intrinsicContentSize }

        var width = 2 * Size.sideMargin + Size.innerMargin
        width += arrow.intrinsicContentSize.width
        width += label.intrinsicContentSize.width
        return CGSize(width: width, height: Size.height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        bg.layer.cornerRadius = Size.height / 2
    }

}
