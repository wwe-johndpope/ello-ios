////
///  ArtistInviteControlsCell.swift
//

import SnapKit


class ArtistInviteControlsCell: CollectionViewCell, ArtistInviteConfigurableCell {
    static let reuseIdentifier = "ArtistInviteControlsCell"

    struct Size {
        static let controlsHeight: CGFloat = 170

        static let margins = UIEdgeInsets(top: 0, left: 15, bottom: 60, right: 15)
        static let descriptionSpacing: CGFloat = 40
        static let submitHeight: CGFloat = 80
    }

    typealias Config = ArtistInviteBubbleCell.Config

    var config = Config() {
        didSet {
            updateConfig()
        }
    }

    fileprivate let descriptionWebView = UIWebView()
    fileprivate let submitButton = StyledButton(style: .artistInviteSubmit)

    override func style() {
        descriptionWebView.scrollView.isScrollEnabled = false
        descriptionWebView.scrollView.scrollsToTop = false
    }

    override func bindActions() {
        submitButton.addTarget(self, action: #selector(tappedSubmitButton), for: .touchUpInside)
    }

    override func setText() {
        submitButton.title = InterfaceString.ArtistInvites.Submit
    }

    override func arrange() {
        contentView.addSubview(descriptionWebView)
        contentView.addSubview(submitButton)

        descriptionWebView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(Size.descriptionSpacing)
            make.bottom.equalTo(submitButton.snp.top)
            make.leading.trailing.equalTo(contentView).inset(Size.margins)
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

extension ArtistInviteControlsCell {
    @objc
    func tappedSubmitButton() {
        let responder: ArtistInviteResponder? = findResponder()
        responder?.tappedArtistInviteSubmitButton()
    }
}

extension StyledButton.Style {
    static let artistInviteSubmit = StyledButton.Style(
        backgroundColor: .greenD1,
        titleColor: .white, highlightedTitleColor: .black,
        fontSize: 24,
        cornerRadius: .rounded
        )
}
