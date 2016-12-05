////
///  EmptyStreamCell.swift
//

import SnapKit


public class EmptyStreamCell: UICollectionViewCell {
    static let reuseEmbedIdentifier = "EmptyStreamCell"

    public struct Size {
        static let bottomMargin: CGFloat = 15
        static let sideMargin: CGFloat = 15
        static let logoWidth: CGFloat = 60
        static let logoBottomPadding: CGFloat = 20
    }

    public var title: String {
        set { label.text = newValue }
        get { return label.text ?? "" }
    }

    private let label = UILabel()
    private let logo = ElloLogoView(config: ElloLogoView.Config.Grey)

    override public init(frame: CGRect) {
        super.init(frame: frame)

        style()
        arrange()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func style() {
        contentView.backgroundColor = .whiteColor()
        label.numberOfLines = 0
        label.font = .defaultFont(12)
        label.textColor = .greyA()
        label.textAlignment = .Center
    }

    func arrange() {
        contentView.addSubview(logo)
        contentView.addSubview(label)

        logo.snp_makeConstraints { make in
            make.width.height.equalTo(Size.logoWidth)
            make.centerX.equalTo(contentView)
        }

        label.snp_makeConstraints { make in
            make.top.equalTo(logo.snp_bottom).offset(Size.logoBottomPadding)
            make.leading.trailing.equalTo(contentView).inset(Size.sideMargin)
            make.bottom.equalTo(contentView).inset(Size.bottomMargin)
        }
    }
}
