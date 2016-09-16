////
///  TextHeaderCell.swift
//

public class TextHeaderCell: UICollectionViewCell {
    static let reuseIdentifier = "TextHeaderCell"
    struct Size {
        static let insets: CGFloat = 10
    }

    private let headerLabel = UILabel()

    var header: NSAttributedString? {
        get { return headerLabel.attributedText }
        set { headerLabel.attributedText = newValue }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()

        style()
        arrange()
    }

    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func style() {
        headerLabel.numberOfLines = 0
    }

    private func arrange() {
        addSubview(headerLabel)

        headerLabel.snp_makeConstraints { make in
            make.top.bottom.equalTo(contentView)
            make.leading.trailing.equalTo(contentView).inset(Size.insets)
        }
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        header = nil
    }

}
