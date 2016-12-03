////
///  OmnibarErrorCell.swift
//

public class OmnibarErrorCell: UITableViewCell {
    class func reuseIdentifier() -> String { return "OmnibarErrorCell" }
    struct Size {
        static let margin = CGFloat(10)
        static let height = CGFloat(75)
    }

    private let label = StyledLabel(style: .Error)

    public var url: NSURL? {
        get { return nil }
        set {
            if let url = newValue {
                label.text = "There was a problem loading the image\n\(url)"
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        label.numberOfLines = 2
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        label.frame = contentView.bounds.inset(all: Size.margin)
        label.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]

        contentView.addSubview(label)
    }

    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
