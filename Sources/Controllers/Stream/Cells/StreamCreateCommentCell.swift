////
///  StreamCreateCommentCell.swift
//

import FLAnimatedImage
import SnapKit


public class StreamCreateCommentCell: UICollectionViewCell {
    static let reuseIdentifier = "StreamCreateCommentCell"

    public struct Size {
        public static let Margins = UIEdgeInsets(top: 12, left: 15, bottom: 12, right: 0)
        public static let AvatarButtonMargin: CGFloat = 6
        public static let ButtonLabelMargin: CGFloat = 30
        public static let ReplyButtonSize: CGFloat = 50
        public static let AvatarSize: CGFloat = 30
        public static let WatchSize: CGFloat = 60
        public static let WatchMargin: CGFloat = 5
    }

    weak var delegate: PostbarDelegate?
    let avatarView = FLAnimatedImageView()
    let createCommentBackground = CreateCommentBackgroundView()
    var replyButtonVisibleConstraint: Constraint!
    var replyButtonHiddenConstraint: Constraint!
    let createCommentLabel = UILabel()
    let replyAllButton = UIButton()
    let watchButton = UIButton()

    var watching = false {
        didSet {
            watchButton.setImage(.Watch, imageStyle: watching ? .Green : .Normal, forState: .Normal)
        }
    }
    var avatarURL: NSURL? {
        willSet(value) {
            if let avatarURL = value {
                avatarView.pin_setImageFromURL(avatarURL)
            }
            else {
                avatarView.pin_cancelImageDownload()
                avatarView.image = nil
            }
        }
    }
    var replyAllVisibility: InteractionVisibility = .Hidden {
        didSet {
            replyAllButton.hidden = (replyAllVisibility != .Enabled)
            if replyAllButton.hidden {
                replyButtonVisibleConstraint.uninstall()
                replyButtonHiddenConstraint.install()
            }
            else {
                replyButtonVisibleConstraint.install()
                replyButtonHiddenConstraint.uninstall()
            }
            setNeedsLayout()
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        style()
        bindActions()
        arrange()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)

        style()
        bindActions()
        arrange()
    }

    private func style() {
        contentView.backgroundColor = .whiteColor()
        avatarView.backgroundColor = .blackColor()
        avatarView.clipsToBounds = true
        replyAllButton.setImage(.ReplyAll, imageStyle: .Normal, forState: .Normal)
        replyAllButton.setImage(.ReplyAll, imageStyle: .Selected, forState: .Highlighted)
        watchButton.setImage(.Watch, imageStyle: .Normal, forState: .Normal)
        watchButton.contentMode = .Center
        createCommentLabel.text = InterfaceString.Post.CreateComment
        createCommentLabel.font = .defaultFont()
        createCommentLabel.textColor = .whiteColor()
        createCommentLabel.textAlignment = .Left
    }

    private func bindActions() {
        replyAllButton.addTarget(self, action: #selector(replyAllTapped), forControlEvents: .TouchUpInside)
        watchButton.addTarget(self, action: #selector(watchTapped), forControlEvents: .TouchUpInside)
    }

    private func arrange() {
        contentView.addSubview(replyAllButton)
        contentView.addSubview(avatarView)
        contentView.addSubview(createCommentBackground)
        contentView.addSubview(watchButton)
        createCommentBackground.addSubview(createCommentLabel)

        avatarView.snp_makeConstraints { make in
            make.leading.equalTo(contentView).offset(Size.Margins.left)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(Size.AvatarSize)
        }

        replyAllButton.snp_makeConstraints { make in
            make.leading.equalTo(createCommentBackground.snp_trailing)
            make.trailing.equalTo(watchButton.snp_leading)
            make.centerY.equalTo(contentView)
            make.width.height.equalTo(Size.ReplyButtonSize)
        }

        watchButton.snp_makeConstraints { make in
            make.top.bottom.equalTo(contentView)
            make.trailing.equalTo(contentView).offset(-Size.WatchMargin)
            make.width.equalTo(Size.WatchSize)
        }

        createCommentBackground.snp_makeConstraints { make in
            make.leading.equalTo(avatarView.snp_trailing).offset(Size.AvatarButtonMargin)
            make.centerY.equalTo(contentView)
            make.height.equalTo(contentView).offset(-Size.Margins.top - Size.Margins.bottom)
            replyButtonVisibleConstraint = make.trailing.equalTo(replyAllButton.snp_leading).constraint
            replyButtonHiddenConstraint = make.trailing.equalTo(watchButton.snp_leading).offset(-Size.Margins.right).constraint
        }
        replyButtonVisibleConstraint.uninstall()

        createCommentLabel.snp_makeConstraints { make in
            make.top.bottom.trailing.equalTo(createCommentBackground)
            make.leading.equalTo(createCommentBackground).offset(Size.ButtonLabelMargin)
        }

        // if this doesn't fix the "stretched create comment" bug, please remove
        setNeedsLayout()
        layoutIfNeeded()
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        avatarView.pin_cancelImageDownload()
        watching = false
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        avatarView.setNeedsLayout()
        avatarView.layoutIfNeeded()
        avatarView.layer.cornerRadius = avatarView.frame.width / CGFloat(2)

        // if this doesn't fix the "stretched create comment" bug, please remove
        createCommentBackground.setNeedsDisplay()
    }

    func replyAllTapped() {
        guard let indexPath = indexPath else { return }
        delegate?.replyToAllButtonTapped(indexPath)
    }

    func watchTapped() {
        guard let indexPath = indexPath else { return }
        delegate?.watchPostTapped(!watching, cell: self, indexPath: indexPath)
    }

}
