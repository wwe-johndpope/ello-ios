////
///  ElloLogoView.swift
//

import QuartzCore
import FLAnimatedImage


class ElloLogoView: UIImageView {

    enum Style {
        case normal
        case grey
        case loading

        var size: CGSize {
            switch self {
            case .loading: return Size.loading
            default: return Size.natural
            }
        }

        var image: UIImage {
            switch self {
            case .normal, .loading: return InterfaceImage.elloLogo.normalImage
            case .grey: return InterfaceImage.elloLogoGrey.normalImage
            }
        }
    }

    struct Size {
        static let natural = CGSize(width: 60, height: 60)
        static let loading = CGSize(width: 30, height: 30)
    }

    fileprivate var wasAnimating = false
    fileprivate var style: ElloLogoView.Style = .normal

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    convenience init() {
        self.init(frame: .zero)
    }

    convenience init(style: Style) {
        self.init(frame: .zero)
        self.style = style
        self.image = self.style.image
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = self.style.image
        self.contentMode = .scaleAspectFit
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil && wasAnimating {
            animateLogo()
        }
    }

    func animateLogo() {
        wasAnimating = true

        self.layer.removeAnimation(forKey: "logo-spin")
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        let angle = layer.value(forKeyPath: "transform.rotation.z") as! NSNumber
        rotate.fromValue = angle
        rotate.toValue = 2 * Double.pi
        rotate.duration = 0.35
        rotate.repeatCount = 1_000_000
        self.layer.add(rotate, forKey: "logo-spin")
    }

    func stopAnimatingLogo() {
        wasAnimating = false

        self.layer.removeAllAnimations()

        let endAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        if let layer = self.layer.presentation() {
            let angle = layer.value(forKeyPath: "transform.rotation.z") as! NSNumber
            endAnimation.fromValue = angle.floatValue
            endAnimation.toValue = 0
            endAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            endAnimation.duration = 0.25
        }
        self.layer.add(endAnimation, forKey: "logo-spin")
    }

    override var intrinsicContentSize: CGSize {
        return style.size
    }
}
