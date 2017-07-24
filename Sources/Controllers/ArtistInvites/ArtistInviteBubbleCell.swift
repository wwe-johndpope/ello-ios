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

        static let cornerRadius: CGFloat = 5
        static let bubbleMargins = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15)
        static let infoMargins = UIEdgeInsets(top: 15, left: 15, bottom: 20, right: 15)
        static let titleCategorySpacing: CGFloat = 20
        static let dotStatusSpacing: CGFloat = 20
        static let statusDateSpacing: CGFloat = 10
        static let descriptionMargins = UIEdgeInsets(top: 20, left: 15, bottom: 15, right: 15)
    }

    struct Config {
        var title: String = ""
        var inviteType: String = ""
        var status: ArtistInvite.Status = .open
        var description: String = ""
        var headerURL: URL?
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
    fileprivate let titleLabel = StyledLabel(style: .artistInviteTitle)
    fileprivate let inviteTypeLabel = StyledLabel(style: .gray)
    fileprivate let statusImage = UIImageView()
    fileprivate let statusLabel = StyledLabel(style: .green)
    fileprivate let dateLabel = StyledLabel(style: .gray)
    fileprivate let descriptionView = UIWebView()

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
        bg.backgroundColor = .greyF2()
    }

    func bindActions() {
        titleLabel.text = "Digital Decade 5"
        inviteTypeLabel.text = "Art Exhibition"
        statusLabel.text = "Open For Submissions"
        dateLabel.text = "June 7 — July 5, 2017"

        let html = StreamTextCellHTML.artistInviteHTML("<p>Hi!</p>")
        descriptionView.loadHTMLString(html, baseURL: URL(string: "/"))
    }

    func arrange() {
        contentView.addSubview(bg)

        bg.addSubview(headerImage)
        bg.addSubview(titleLabel)
        bg.addSubview(inviteTypeLabel)
        bg.addSubview(statusImage)
        bg.addSubview(statusLabel)
        bg.addSubview(dateLabel)
        bg.addSubview(descriptionView)

        bg.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(Size.bubbleMargins)
        }

        headerImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(bg)
            make.height.equalTo(Size.headerImageHeight)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(bg).offset(Size.infoMargins.left)
            make.top.equalTo(headerImage.snp.bottom).offset(Size.infoMargins.top)
        }

        inviteTypeLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(Size.titleCategorySpacing)
        }

        statusImage.snp.makeConstraints { make in
            make.centerY.equalTo(inviteTypeLabel)
            make.trailing.equalTo(statusLabel.snp.leading).offset(-Size.dotStatusSpacing)
        }

        statusLabel.snp.makeConstraints { make in
            make.trailing.equalTo(bg).offset(-Size.infoMargins.right)
            make.centerY.equalTo(inviteTypeLabel)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(Size.statusDateSpacing)
            make.leading.equalTo(statusLabel)
        }

        descriptionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(bg).inset(Size.descriptionMargins)
            make.top.equalTo(dateLabel.snp.bottom).offset(Size.descriptionMargins.top)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        config = Config()
    }

    func updateConfig() {
        // headerImage
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

        let html = StreamTextCellHTML.artistInviteHTML(config.description)
        descriptionView.loadHTMLString(html, baseURL: URL(string: "/"))
    }
}

extension ArtistInviteBubbleCell.Config {
    static func fromArtistInvite(_ artistInvite: ArtistInvite) -> ArtistInviteBubbleCell.Config {
        let config = ArtistInviteBubbleCell.Config()
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
        case .preview: return InterfaceImage.dot.normalImage
        case .upcoming: return InterfaceImage.dot.normalImage
        case .open: return InterfaceImage.dot.greenImage
        case .selecting: return InterfaceImage.dot.selectedImage
        case .closed: return InterfaceImage.dot.redImage
        }
    }

    var labelStyle: StyledLabel.Style {
        switch self {
        case .preview: return .gray
        case .upcoming: return .gray
        case .open: return .green
        case .selecting: return .black
        case .closed: return .error
        }
    }
}
