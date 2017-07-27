////
///  ArtistInviteBubbleCell.swift
//

import SnapKit
import SVGKit


class ArtistInviteBubbleCell: UICollectionViewCell, ArtistInviteConfigurableCell {
    static let reuseIdentifier = "ArtistInviteBubbleCell"

    struct Size {
        static let headerImageHeight: CGFloat = 230
        static let infoTotalHeight: CGFloat = 130

        static let logoImageSize = CGSize(width: 337.5, height: 190)
        static let cornerRadius: CGFloat = 5
        static let bubbleMargins = UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 15)
        static let infoMargins = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)
        static let titleStatusSpacing: CGFloat = 14
        static let dotYOffset: CGFloat = -1
        static let dotStatusSpacing: CGFloat = 25
        static let statusTypeDateSpacing: CGFloat = 10
        static let descriptionMargins = UIEdgeInsets(top: 20, left: 15, bottom: 15, right: 15)
    }

    struct Config {
        var title: String = ""
        var inviteType: String = ""
        var status: ArtistInvite.Status = .open
        var shortDescription: String = ""
        var longDescription: String = ""
        var headerURL: URL?
        var logoURL: URL?
        var openedAt: Date?
        var closedAt: Date?
    }

    var config = Config() {
        didSet {
            updateConfig()
        }
    }

    fileprivate let bg = UIView()
    fileprivate let headerImage = FLAnimatedImageView()
    fileprivate let logoImage = UIImageView()
    fileprivate let titleLabel = StyledLabel(style: .artistInviteTitle)
    fileprivate let statusImage = UIImageView()
    fileprivate let statusLabel = StyledLabel()
    fileprivate let inviteTypeLabel = StyledLabel(style: .gray)
    fileprivate let dateLabel = StyledLabel(style: .gray)
    fileprivate let descriptionWebView = UIWebView()

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
        bg.backgroundColor = .greyF2
        headerImage.contentMode = .scaleAspectFill
        headerImage.clipsToBounds = true
        logoImage.contentMode = .scaleAspectFit
        logoImage.clipsToBounds = true
        descriptionWebView.scrollView.isScrollEnabled = false
        descriptionWebView.scrollView.scrollsToTop = false
        descriptionWebView.isUserInteractionEnabled = false
    }

    func bindActions() {
    }

    func arrange() {
        contentView.addSubview(bg)

        bg.addSubview(headerImage)
        bg.addSubview(logoImage)
        bg.addSubview(titleLabel)
        bg.addSubview(statusImage)
        bg.addSubview(statusLabel)
        bg.addSubview(inviteTypeLabel)
        bg.addSubview(dateLabel)
        bg.addSubview(descriptionWebView)

        bg.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(Size.bubbleMargins)
        }

        headerImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(bg)
            make.height.equalTo(Size.headerImageHeight)
        }

        logoImage.snp.makeConstraints { make in
            make.center.equalTo(headerImage)
            make.size.equalTo(Size.logoImageSize).priority(Priority.medium)
            make.width.lessThanOrEqualTo(bg).priority(Priority.required)
            make.height.equalTo(logoImage.snp.width).multipliedBy(Size.logoImageSize.height / Size.logoImageSize.width).priority(Priority.required)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(bg).inset(Size.infoMargins)
            make.top.equalTo(headerImage.snp.bottom).offset(Size.infoMargins.top)
        }

        statusImage.snp.makeConstraints { make in
            make.centerY.equalTo(statusLabel).offset(Size.dotYOffset)
            make.leading.equalTo(titleLabel)
        }

        statusLabel.snp.makeConstraints { make in
            make.leading.equalTo(statusImage.snp.trailing).offset(Size.dotStatusSpacing)
            make.top.equalTo(titleLabel.snp.bottom).offset(Size.titleStatusSpacing)
        }

        inviteTypeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(statusLabel.snp.bottom).offset(Size.statusTypeDateSpacing)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(inviteTypeLabel.snp.bottom).offset(Size.statusTypeDateSpacing)
            make.leading.trailing.equalTo(titleLabel)
        }

        descriptionWebView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(bg).inset(Size.descriptionMargins)
            make.top.equalTo(dateLabel.snp.bottom).offset(Size.descriptionMargins.top)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        config = Config()
    }

    func updateConfig() {
        titleLabel.text = config.title
        inviteTypeLabel.text = config.inviteType

        statusImage.image = config.status.image
        statusLabel.text = config.status.text
        statusLabel.style = config.status.labelStyle

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

        let html = StreamTextCellHTML.artistInviteHTML(config.shortDescription)
        descriptionWebView.loadHTMLString(html, baseURL: URL(string: "/"))
    }
}

extension ArtistInviteBubbleCell.Config {
    static func fromArtistInvite(_ artistInvite: ArtistInvite) -> ArtistInviteBubbleCell.Config {
        var config = ArtistInviteBubbleCell.Config()
        config.title = artistInvite.title
        config.shortDescription = artistInvite.shortDescription
        config.longDescription = artistInvite.longDescription
        config.inviteType = artistInvite.inviteType
        config.status = artistInvite.status
        config.openedAt = artistInvite.openedAt
        config.closedAt = artistInvite.closedAt
        config.headerURL = artistInvite.headerImage?.largeOrBest?.url
        config.logoURL = artistInvite.logoImage?.optimized?.url
        return config
    }
}

extension ArtistInvite.Status {
    var text: String {
        switch self {
        case .preview: return InterfaceString.ArtistInvites.PreviewStatus
        case .upcoming: return InterfaceString.ArtistInvites.UpcomingStatus
        case .open: return InterfaceString.ArtistInvites.OpenStatus
        case .selecting: return InterfaceString.ArtistInvites.SelectingStatus
        case .closed: return InterfaceString.ArtistInvites.ClosedStatus
        }
    }

    var image: UIImage? {
        switch self {
        case .preview: return SVGKImage(named: "artist_invite_status_preview.svg").uiImage.withRenderingMode(.alwaysOriginal)
        case .upcoming: return SVGKImage(named: "artist_invite_status_upcoming.svg").uiImage.withRenderingMode(.alwaysOriginal)
        case .open: return SVGKImage(named: "artist_invite_status_open.svg").uiImage.withRenderingMode(.alwaysOriginal)
        case .selecting: return SVGKImage(named: "artist_invite_status_selecting.svg").uiImage.withRenderingMode(.alwaysOriginal)
        case .closed: return SVGKImage(named: "artist_invite_status_closed.svg").uiImage.withRenderingMode(.alwaysOriginal)
        }
    }

    var labelStyle: StyledLabel.Style {
        switch self {
        case .preview: return .artistInvitePreview
        case .upcoming: return .artistInviteUpcoming
        case .open: return .artistInviteOpen
        case .selecting: return .artistInviteSelecting
        case .closed: return .artistInviteClosed
        }
    }
}

extension StyledLabel.Style {
    static let artistInvitePreview = StyledLabel.Style(
        textColor: UIColor(hex: 0x0409FE)
        )
    static let artistInviteUpcoming = StyledLabel.Style(
        textColor: UIColor(hex: 0xC000FF)
        )
    static let artistInviteOpen = StyledLabel.Style(
        textColor: UIColor(hex: 0x00D100)
        )
    static let artistInviteSelecting = StyledLabel.Style(
        textColor: UIColor(hex: 0xFDB02A)
        )
    static let artistInviteClosed = StyledLabel.Style(
        textColor: UIColor(hex: 0xFE0404)
        )
}
