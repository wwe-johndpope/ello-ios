////
///  EmptyStreamCell.swift
//

import SnapKit


public class EmptyStreamCell: UICollectionViewCell {
    static let reuseEmbedIdentifier = "EmptyStreamCell"

    public struct Size {
        static let sideMargin: CGFloat = 15
        static let topMargin: CGFloat = 15
        static let logoWidth: CGFloat = 60
        static let labelBottomPadding: CGFloat = 10
    }

    public var title: String {
        set { label.text = newValue }
        get { return label.text ?? "" }
    }

    let label = UILabel()
    let logo = ElloLogoView()

    override public init(frame: CGRect) {
        super.init(frame: frame)

        style()
        arrange()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func style() {
        label.numberOfLines = 0
    }

    func arrange() {
        contentView.addSubview(label)
        contentView.addSubview(logo)

        label.snp_makeConstraints { make in
            make.top.equalTo(contentView).offset(Size.topMargin)
            make.leading.trailing.equalTo(contentView).inset(Size.sideMargin)
        }

        logo.snp_makeConstraints { make in
            make.top.equalTo(label).offset(Size.labelBottomPadding)
            make.width.height.equalTo(Size.logoWidth)
            make.centerX.equalTo(contentView)
        }
    }
}
