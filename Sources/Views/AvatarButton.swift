////
///  AvatarButton.swift
//

public class AvatarButton: UIButton {
    // for specs; ensure the correct URL is assigned
    public var imageURL: NSURL?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        clipsToBounds = false
    }

    func setUserAvatarURL(url: NSURL?) {
        self.imageURL = url
        self.setDefaultImage()

        if let url = url {
            self.pin_setImageFromURL(url) { result in
                if result.image != nil {
                    if result.resultType != .MemoryCache {
                        self.alpha = 0
                        UIView.animateWithDuration(0.3,
                            delay:0.0,
                            options:UIViewAnimationOptions.CurveLinear,
                            animations: {
                                self.alpha = 1.0
                            }, completion: nil)
                    }
                    else {
                        self.alpha = 1.0
                    }
                }
            }
        }
    }

    func setDefaultImage() {
        pin_cancelImageDownload()
        setImage(nil, forState: .Normal)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        if let imageView = self.imageView {
            imageView.layer.cornerRadius = imageView.bounds.size.height / CGFloat(2)
        }
    }

}
