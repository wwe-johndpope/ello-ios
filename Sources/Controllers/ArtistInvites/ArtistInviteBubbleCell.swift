////
///  ArtistInviteBubbleCell.swift
//

import SnapKit


// @objc
// protocol ArtistInviteCellResponder: class {
//     func artistInviteTapped(cell: ArtistInviteCell)
// }

class ArtistInviteBubbleCell: UICollectionViewCell {
    static let reuseIdentifier = "ArtistInviteBubbleCell"

    struct Size {
        static let headerImageHeight: CGFloat = 230
        static let infoTotalHeight: CGFloat = 117

        static let bubbleMargins = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)
        static let infoMargins = UIEdgeInsets(top: 15, left: 15, bottom: 20, right: 15)
        static let titleCategorySpacing: CGFloat = 20
        static let cornerRadius: CGFloat = 5
        static let dotStatusSpacing: CGFloat = 20
        static let statusDateSpacing: CGFloat = 10
        static let descriptionMargins = UIEdgeInsets(top: 20, left: 15, bottom: 15, right: 15)
    }

    struct Config {
    }

    var config = Config() {
        didSet {
            updateConfig()
        }
    }

    fileprivate let bg = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        bindActions()
        arrange()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func style() {
        bg.layer.cornerRadius = Size.cornerRadius
        bg.clipsToBounds = true
    }

    func bindActions() {
    }

    func arrange() {
        contentView.addSubview(bg)

        bg.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(Size.bubbleMargins)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        config = Config()
    }

    func updateConfig() {
    }
}

extension ArtistInviteBubbleCell.Config {
    static func fromArtistInvite(_ artistInvite: ArtistInvite) -> ArtistInviteBubbleCell.Config {
        let config = ArtistInviteBubbleCell.Config()
        return config
    }
}
