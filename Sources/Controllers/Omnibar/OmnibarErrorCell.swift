////
///  OmnibarErrorCell.swift
//

class OmnibarErrorCell: UITableViewCell {
    static let reuseIdentifier = "OmnibarErrorCell"
    struct Size {
        static let margin = CGFloat(10)
        static let height = CGFloat(75)
    }

    private let label = StyledLabel(style: .error)

    var url: URL? {
        get { return nil }
        set {
            if let url = newValue {
                label.text = InterfaceString.Omnibar.LoadingImageError(url: url)
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        label.numberOfLines = 2
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        label.frame = contentView.bounds.inset(all: Size.margin)
        label.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        contentView.addSubview(label)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
