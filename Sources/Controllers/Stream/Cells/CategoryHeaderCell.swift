////
///  CategoryHeaderCell.swift
//

import SnapKit
import FLAnimatedImage
import PINRemoteImage

public class CategoryHeaderCell: UICollectionViewCell {
    static let reuseIdentifier = "CategoryHeaderCell"

    public struct Size {
        static let defaultMargin: CGFloat = 15
        static let avatarMargin: CGFloat = 10
        static let avatarSize: CGFloat = 30
        static let circleBottomInset: CGFloat = 10
        static let failImageWidth: CGFloat = 140
        static let failImageHeight: CGFloat = 160
    }

    let imageView = FLAnimatedImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let learnMoreButton = UIButton()
    let postedByButton = UIButton()
    let postedByAvatar = AvatarButton()

    let circle = PulsingCircle()
    let failImage = UIImageView()
    let failBackgroundView = UIView()
    var failWidthConstraint: Constraint!
    var failHeightConstraint: Constraint!

    private var imageSize: CGSize?
    private var aspectRatio: CGFloat? {
        guard let imageSize = imageSize else { return nil }
        return imageSize.width / imageSize.height
    }

    var calculatedHeight: CGFloat? {
        guard let aspectRatio = aspectRatio else {
            return nil
        }
        return frame.width / aspectRatio
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        style()
        arrange()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setImageURL(url: NSURL) {
        imageView.image = nil
        imageView.alpha = 0
        circle.pulse()
        failImage.hidden = true
        failImage.alpha = 0
        imageView.backgroundColor = .whiteColor()
        loadImage(url)
    }

    public func setImage(image: UIImage) {
        imageView.pin_cancelImageDownload()
        imageView.image = image
        imageView.alpha = 1
        failImage.hidden = true
        failImage.alpha = 0
        imageView.backgroundColor = .whiteColor()
    }
}

private extension CategoryHeaderCell {

    func style() {
        titleLabel.text = "TEMP"
        titleLabel.textColor = .whiteColor()
        titleLabel.font = .defaultFont(20)
        descriptionLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc consectetur molestie faucibus. Phasellus iaculis pellentesque felis eu fringilla. Ut in sollicitudin nisi. Praesent in mauris tortor. Nam interdum, magna eu pellentesque scelerisque, dui ipsum adipiscing ante, vel ullamcorper nisl sapien id arcu. Nullam egestas diam eu felis mollis sit amet cursus enim vehicula. Quisque eu tellus id erat pellentesque consequat. Maecenas fermentum faucibus magna, eget dictum nisi congue sed. Quisque a justo a nisi eleifend facilisis sit amet at augue. Sed a sapien vitae augue hendrerit porta vel eu ligula. Proin enim urna, faucibus in vestibulum tincidunt, commodo sit amet orci. Vestibulum ac sem urna, quis mattis urna. Nam eget ullamcorper ligula. Nam volutpat, arcu vel auctor dignissim, tortor nisi sodales enim, et vestibulum nulla dui id ligula. Nam ullamcorper, augue ut interdum vulputate, eros mauris lobortis sapien, ac sodales dui eros ac elit."
        descriptionLabel.textColor = .whiteColor()
        descriptionLabel.font = .defaultFont()
        descriptionLabel.numberOfLines = 0
        learnMoreButton.setTitle("Learn more CTA", forState: .Normal)
        learnMoreButton.titleLabel?.font = .defaultFont()
        postedByButton.setTitle("Posted by @colinta", forState: .Normal)
        postedByButton.titleLabel?.font = .defaultFont()

        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFill
        failBackgroundView.backgroundColor = .whiteColor()
    }

    func arrange() {
        contentView.addSubview(circle)
        contentView.addSubview(failBackgroundView)
        contentView.addSubview(failImage)

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(learnMoreButton)
        contentView.addSubview(postedByButton)
        contentView.addSubview(postedByAvatar)

        circle.snp_makeConstraints { make in
            make.edges.equalTo(contentView)
        }

        failBackgroundView.snp_makeConstraints { make in
            make.edges.equalTo(contentView)
        }

        failImage.snp_makeConstraints { make in
            make.center.equalTo(contentView)
            failWidthConstraint = make.leading.equalTo(Size.failImageWidth).constraint
            failHeightConstraint = make.leading.equalTo(Size.failImageHeight).constraint
        }

        imageView.snp_makeConstraints { make in
            make.edges.equalTo(contentView)
        }

        titleLabel.snp_makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(Size.defaultMargin)
        }

        descriptionLabel.snp_makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottom).offset(Size.defaultMargin)
            make.leading.trailing.equalTo(self).inset(Size.defaultMargin)
        }

        learnMoreButton.snp_makeConstraints { make in
            make.leading.bottom.equalTo(self).inset(Size.defaultMargin)
        }

        postedByButton.snp_makeConstraints { make in
            make.trailing.equalTo(postedByAvatar.snp_leading).offset(-Size.avatarMargin)
            make.bottom.equalTo(self).inset(Size.defaultMargin)
        }

        postedByAvatar.snp_makeConstraints { make in
            make.width.height.equalTo(Size.avatarSize)
            make.leading.bottom.equalTo(self).inset(Size.avatarMargin)
        }

    }

    func loadImage(url: NSURL) {
        guard url.scheme != "" else {
            if let urlWithScheme = NSURL(string: "https:\(url.absoluteString)") {
                loadImage(urlWithScheme)
            }
            return
        }
        self.imageView.pin_setImageFromURL(url) { result in
            let success = result.image != nil || result.animatedImage != nil
            let isAnimated = result.animatedImage != nil
            if success {
                let imageSize = isAnimated ? result.animatedImage.size : result.image.size
                self.imageSize = imageSize

                if result.resultType != .MemoryCache {
                    self.imageView.alpha = 0
                    UIView.animateWithDuration(0.3,
                                               delay:0.0,
                                               options:UIViewAnimationOptions.CurveLinear,
                                               animations: {
                                                self.imageView.alpha = 1.0
                        }, completion: { _ in
                            self.circle.stopPulse()
                    })
                }
                else {
                    self.imageView.alpha = 1.0
                    self.circle.stopPulse()
                }

                self.layoutIfNeeded()
            }
            else {
                self.imageLoadFailed()
            }
        }
    }

    func imageLoadFailed() {
        failImage.hidden = false
        failBackgroundView.hidden = false
        circle.stopPulse()
        imageSize = nil
//        nextTick { postNotification(StreamNotification.AnimateCellHeightNotification, value: self) }
        UIView.animateWithDuration(0.15) {
            self.failImage.alpha = 1.0
            self.imageView.backgroundColor = UIColor.greyF1()
            self.failBackgroundView.backgroundColor = UIColor.greyF1()
            self.imageView.alpha = 1.0
            self.failBackgroundView.alpha = 1.0
        }
    }

}
