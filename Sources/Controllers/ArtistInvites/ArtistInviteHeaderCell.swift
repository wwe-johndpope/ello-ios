////
///  ArtistInviteHeaderCell.swift
//

import SnapKit
import FLAnimatedImage


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
    fileprivate let headerOverlay = UIView()
    fileprivate let logoImage = UIImageView()
    fileprivate let titleLabel = StyledLabel(style: .artistInviteDetailTitle)
    fileprivate let statusLabel = StyledLabel()
    fileprivate let inviteTypeLabel = StyledLabel(style: .artistInviteDetailInfo)
    fileprivate let dateLabel = StyledLabel(style: .artistInviteDetailInfo)

    override func style() {
        headerImage.contentMode = .scaleAspectFill
        headerImage.clipsToBounds = true
        headerOverlay.backgroundColor = .black
        headerOverlay.alpha = 0.3
        logoImage.contentMode = .scaleAspectFit
        logoImage.clipsToBounds = true
    }

    override func arrange() {
        contentView.addSubview(headerImage)
        contentView.addSubview(headerOverlay)
        contentView.addSubview(logoImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(inviteTypeLabel)
        contentView.addSubview(dateLabel)

        headerImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(Size.headerImageHeight)
        }

        headerOverlay.snp.makeConstraints { make in
            make.edges.equalTo(headerImage)
        }

        logoImage.snp.makeConstraints { make in
            make.center.equalTo(headerImage)
            make.size.equalTo(Size.logoImageSize)
            make.width.lessThanOrEqualTo(contentView).priority(Priority.required)
            make.height.equalTo(logoImage.snp.width).multipliedBy(Size.logoImageSize.height / Size.logoImageSize.width).priority(Priority.required)
        }
        logoImage.setContentCompressionResistancePriority(Priority.low.value, for: .vertical)
        logoImage.setContentCompressionResistancePriority(Priority.low.value, for: .horizontal)

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
        case .preview: return .artistInviteDetailPreview
        case .upcoming: return .artistInviteDetailUpcoming
        case .open: return .artistInviteDetailOpen
        case .selecting: return .artistInviteDetailSelecting
        case .closed: return .artistInviteDetailClosed
        }
    }
}

extension StyledLabel.Style {
    static let artistInviteDetailTitle = StyledLabel.Style(
        textColor: .black,
        fontFamily: .artistInviteTitle
        )
    static let artistInviteDetailInfo = StyledLabel.Style(
        textColor: .greyA,
        fontFamily: .artistInviteDetail
        )

    static let artistInviteDetailPreview = StyledLabel.Style(
        textColor: UIColor(hex: 0x0409FE),
        fontFamily: .artistInviteDetail
        )
    static let artistInviteDetailUpcoming = StyledLabel.Style(
        textColor: UIColor(hex: 0xC000FF),
        fontFamily: .artistInviteDetail
        )
    static let artistInviteDetailOpen = StyledLabel.Style(
        textColor: UIColor(hex: 0x00D100),
        fontFamily: .artistInviteDetail
        )
    static let artistInviteDetailSelecting = StyledLabel.Style(
        textColor: UIColor(hex: 0xFDB02A),
        fontFamily: .artistInviteDetail
        )
    static let artistInviteDetailClosed = StyledLabel.Style(
        textColor: UIColor(hex: 0xFE0404),
        fontFamily: .artistInviteDetail
        )
}
