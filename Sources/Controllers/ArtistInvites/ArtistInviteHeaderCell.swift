////
///  ArtistInviteHeaderCell.swift
//

import SnapKit


class ArtistInviteHeaderCell: CollectionViewCell, ArtistInviteConfigurableCell {
    static let reuseIdentifier = "ArtistInviteHeaderCell"

    struct Size {
        static let headerImageHeight: CGFloat = 220
        static let totalTextHeight: CGFloat = 196

        static let logoImageSize = ArtistInviteBubbleCell.Size.logoImageSize
        static let textMargins = UIEdgeInsets(top: 20, left: 15, bottom: 30, right: 15)
        static let statusSpacing: CGFloat = 10
        static let inviteTypeSpacing: CGFloat = 30
        static let dateSpacing: CGFloat = 10
    }

    typealias Config = ArtistInviteBubbleCell.Config

    var config = Config() {
        didSet {
            updateConfig()
        }
    }

    fileprivate let headerImage = FLAnimatedImageView()
    fileprivate let logoImage = UIImageView()
    fileprivate let titleLabel = StyledLabel(style: .artistInvitedDetailTitle)
    fileprivate let statusLabel = StyledLabel()
    fileprivate let inviteTypeLabel = StyledLabel(style: .artistInvitedDetailInfo)
    fileprivate let dateLabel = StyledLabel(style: .artistInvitedDetailInfo)

    override func style() {
        headerImage.contentMode = .scaleAspectFill
        headerImage.clipsToBounds = true
        logoImage.contentMode = .scaleAspectFit
        logoImage.clipsToBounds = true
    }

    override func arrange() {
        contentView.addSubview(headerImage)
        contentView.addSubview(logoImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(inviteTypeLabel)
        contentView.addSubview(dateLabel)

        headerImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(Size.headerImageHeight)
        }

        logoImage.snp.makeConstraints { make in
            make.center.equalTo(headerImage)
            make.size.equalTo(Size.logoImageSize)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView).inset(Size.textMargins)
            make.top.equalTo(headerImage.snp.bottom).offset(Size.textMargins.top)
        }

        statusLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(Size.statusSpacing)
        }

        inviteTypeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(statusLabel.snp.bottom).offset(Size.inviteTypeSpacing)
        }

        dateLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(inviteTypeLabel.snp.bottom).offset(Size.dateSpacing)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        config = Config()
    }

    func updateConfig() {
        titleLabel.text = config.title
        statusLabel.text = config.status.text
        statusLabel.style = config.status.detailLabelStyle
        inviteTypeLabel.text = config.inviteType

        let dateText: String
        if let openedAt = config.openedAt {
            if let closedAt = config.closedAt {
                dateText = "\(openedAt.monthDay()) — \(closedAt.monthDayYear())"
            }
            else {
                dateText = "Opens \(openedAt.monthDayYear())"
            }
        }
        else if let closedAt = config.closedAt {
            dateText = "Ends \(closedAt.monthDayYear())"
        }
        else {
            dateText = ""
        }
        dateLabel.text = dateText

        let images: [(URL?, UIImageView)] = [
            (config.headerURL, headerImage),
            (config.logoURL, logoImage),
        ]
        for (url, imageView) in images {
            if let url = url {
                imageView.pin_setImage(from: url)
            }
            else {
                imageView.pin_cancelImageDownload()
                imageView.image = nil
            }
        }
    }
}

extension ArtistInvite.Status {
    var detailLabelStyle: StyledLabel.Style {
        switch self {
        case .preview: return .artistInvitedDetailPreview
        case .upcoming: return .artistInvitedDetailUpcoming
        case .open: return .artistInvitedDetailOpen
        case .selecting: return .artistInvitedDetailSelecting
        case .closed: return .artistInvitedDetailClosed
        }
    }
}

extension StyledLabel.Style {
    static let artistInvitedDetailInfo = StyledLabel.Style(
        textColor: .greyA,
        fontFamily: .artistInviteTitle
        )
    static let artistInvitedDetailTitle = StyledLabel.Style(
        textColor: .black,
        fontFamily: .artistInviteTitle
        )

    static let artistInvitedDetailPreview = StyledLabel.Style(
        textColor: UIColor(hex: 0x0409FE),
        fontFamily: .artistInviteTitle
        )
    static let artistInvitedDetailUpcoming = StyledLabel.Style(
        textColor: UIColor(hex: 0xC000FF),
        fontFamily: .artistInviteTitle
        )
    static let artistInvitedDetailOpen = StyledLabel.Style(
        textColor: UIColor(hex: 0x00D100),
        fontFamily: .artistInviteTitle
        )
    static let artistInvitedDetailSelecting = StyledLabel.Style(
        textColor: UIColor(hex: 0xFDB02A),
        fontFamily: .artistInviteTitle
        )
    static let artistInvitedDetailClosed = StyledLabel.Style(
        textColor: UIColor(hex: 0xFE0404),
        fontFamily: .artistInviteTitle
        )
}
