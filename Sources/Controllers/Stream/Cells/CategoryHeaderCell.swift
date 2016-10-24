////
///  CategoryHeaderCell.swift
//

import SnapKit
import FLAnimatedImage
import PINRemoteImage

public class CategoryHeaderCell: UICollectionViewCell {
    static let reuseIdentifier = "CategoryHeaderCell"

    public struct Size {
        static let circleBottomInset: CGFloat = 10
        static let failImageWidth: CGFloat = 140
        static let failImageHeight: CGFloat = 160
    }

    let imageView = FLAnimatedImageView()
    let circle = PulsingCircle()
    let failImage = UIImageView()
    let failBackgroundView = UIView()
    var serverProvidedAspectRatio: CGFloat?
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
        imageView.backgroundColor = UIColor.whiteColor()
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

    func arrange() {
        contentView.addSubview(circle)
        contentView.addSubview(failBackgroundView)
        contentView.addSubview(imageView)
        contentView.addSubview(failImage)

        circle.snp_makeConstraints { make in
            make.edges.equalTo(contentView)
        }

        failBackgroundView.snp_makeConstraints { make in
            make.edges.equalTo(contentView)
        }

        imageView.snp_makeConstraints { make in
            make.edges.equalTo(contentView)
        }

        failImage.snp_makeConstraints { make in
            make.center.equalTo(contentView)
            failWidthConstraint = make.leading.equalTo(Size.failImageWidth).constraint
            failHeightConstraint = make.leading.equalTo(Size.failImageHeight).constraint
        }

    }

    func style() {
        failBackgroundView.backgroundColor = .whiteColor()
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

                if self.serverProvidedAspectRatio == nil {
//                    postNotification(StreamNotification.AnimateCellHeightNotification, value: self)
                }

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
