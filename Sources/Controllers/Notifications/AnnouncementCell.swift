////
///  AnnouncementCell.swift
//

import SnapKit


class AnnouncementCell: UICollectionViewCell {
    static let reuseIdentifier = "AnnouncementCell"

    struct Size {
        static let margins: CGFloat = 15
        static let imageSize: CGFloat = 80
        static let textLeadingMargin: CGFloat = 15
        static let textVerticalMargin: CGFloat = 15
        static let closeButtonMargin: CGFloat = 15
        static let closeButtonSize: CGFloat = 50
    }

    public struct Config {
        var title: String?
        var body: String?
        var imageURL: NSURL?
        var image: UIImage? // for testing
        var callToAction: String?

        public init() {}
    }

    weak var delegate: AnnouncementCellDelegate?

    public var config = Config() {
        didSet {
            titleLabel.text = config.title
            bodyLabel.text = config.body
            callToActionButton.title = config.callToAction

            if let url = config.imageURL {
                imageView.pin_setImageFromURL(url) { _ in }
            }
            else {
                imageView.pin_cancelImageDownload()
                imageView.image = config.image // for testing, nice to be able to assign an image sync'ly
            }
        }
    }

    private let imageView = FLAnimatedImageView()
    private let closeButton = UIButton()
    private let titleLabel = StyledLabel(style: .BoldWhite)
    private let bodyLabel = StyledLabel(style: .White)
    private let callToActionButton = StyledButton(style: .WhiteUnderlined)

    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        bindActions()
        arrange()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func style() {
        contentView.backgroundColor = .blackColor()
        closeButton.setImages(.X)

        titleLabel.numberOfLines = 0
        bodyLabel.numberOfLines = 0
        callToActionButton.contentHorizontalAlignment = .Left
    }

    func bindActions() {
        closeButton.addTarget(self, action: #selector(markAsRead), forControlEvents: .TouchUpInside)
    }

    func arrange() {
        contentView.addSubview(imageView)
        contentView.addSubview(closeButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(callToActionButton)

        imageView.snp_makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(Size.margins)
            make.width.height.equalTo(Size.imageSize)
        }
        closeButton.snp_makeConstraints { make in
            make.top.trailing.equalTo(contentView)
            make.width.height.equalTo(Size.closeButtonSize)
        }
        titleLabel.snp_makeConstraints { make in
            make.leading.equalTo(imageView.snp_trailing).offset(Size.textLeadingMargin)
            make.top.equalTo(imageView)
            make.trailing.equalTo(closeButton.snp_leading)
        }
        bodyLabel.snp_makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottom).offset(Size.textVerticalMargin)
            make.leading.trailing.equalTo(titleLabel)
        }
        callToActionButton.snp_makeConstraints { make in
            make.top.equalTo(bodyLabel.snp_bottom).offset(Size.textVerticalMargin)
            make.leading.trailing.equalTo(titleLabel)
        }
    }

}

extension AnnouncementCell {
    override public func prepareForReuse() {
        config = Config()
    }
}

extension AnnouncementCell {
    func markAsRead() {
        delegate?.markAnnouncementAsRead(cell: self)
    }
}
