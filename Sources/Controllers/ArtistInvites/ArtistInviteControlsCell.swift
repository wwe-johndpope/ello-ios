////
///  ArtistInviteControlsCell.swift
//

import SnapKit


class ArtistInviteControlsCell: UICollectionViewCell, ArtistInviteConfigurableCell {
    static let reuseIdentifier = "ArtistInviteControlsCell"

    struct Size {
        static let controlsHeight: CGFloat = 210

        static let margins = UIEdgeInsets(top: 0, left: 15, bottom: 60, right: 15)
        static let submissionsHeight: CGFloat = 40
        static let descriptionSpacing: CGFloat = 30
        static let submitHeight: CGFloat = 80
    }

    typealias Config = ArtistInviteBubbleCell.Config

    var config = Config() {
        didSet {
            updateConfig()
        }
    }

    fileprivate let submissionsButton = StyledButton(style: .artistInviteSubmissions)
    fileprivate let descriptionWebView = UIWebView()
    fileprivate let submitButton = StyledButton(style: .artistInviteSubmit)

    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        bindActions()
        setText()
        arrange()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func style() {
        submissionsButton.titleEdgeInsets.top = 4
        descriptionWebView.scrollView.isScrollEnabled = false
        descriptionWebView.scrollView.scrollsToTop = false
    }

    func bindActions() {
    }

    func setText() {
        submissionsButton.title = InterfaceString.ArtistInvites.SeeSubmissions
        submitButton.title = InterfaceString.ArtistInvites.Submit
    }

    func arrange() {
        contentView.addSubview(submissionsButton)
        contentView.addSubview(descriptionWebView)
        contentView.addSubview(submitButton)

        submissionsButton.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.trailing.equalTo(contentView).inset(Size.margins)
            make.height.equalTo(Size.submissionsHeight)
        }

        descriptionWebView.snp.makeConstraints { make in
            make.top.equalTo(submissionsButton.snp.bottom).offset(Size.descriptionSpacing)
            make.bottom.equalTo(submitButton.snp.top)
            make.leading.trailing.equalTo(submissionsButton)
        }

        submitButton.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(contentView).inset(Size.margins)
            make.height.equalTo(Size.submitHeight)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        config = Config()
    }

    func updateConfig() {
        let html = StreamTextCellHTML.postHTML(config.longDescription)
        descriptionWebView.loadHTMLString(html, baseURL: URL(string: "/"))
    }
}

extension StyledButton.Style {
    static let artistInviteSubmissions = StyledButton.Style(
        backgroundColor: .white, highlightedBackgroundColor: .greenD1,
        titleColor: .greenD1, highlightedTitleColor: .white,
        borderColor: .greenD1, highlightedBorderColor: .white,
        cornerRadius: .rounded
        )
    static let artistInviteSubmit = StyledButton.Style(
        backgroundColor: .greenD1,
        titleColor: .white, highlightedTitleColor: .black,
        fontSize: 24,
        cornerRadius: .rounded
        )
}
