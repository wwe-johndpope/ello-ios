////
///  InterpolatedLoadingView.swift
//

public class InterpolatedLoadingView: UIView {
    public var round = false {
        didSet { setNeedsLayout() }
    }
    private var animating = false

    override public func didMoveToWindow() {
        super.didMoveToWindow()
        self.animateIfPossible()
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.animateIfPossible()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        if round {
            layer.cornerRadius = min(frame.size.width, frame.size.height) / 2
        }
        else {
            layer.cornerRadius = 0
        }
    }

    private func animateIfPossible() {
        if !animating && window != nil && superview != nil {
            animate()
        }
        else {
            animating = false
        }
    }

    private func animate() {
        animating = true

        self.layer.removeAnimationForKey("interpolate")
        let rotate = CABasicAnimation(keyPath: "backgroundColor")
        rotate.fromValue = UIColor(hex: 0xDDDDDD).CGColor
        rotate.toValue = UIColor(hex: 0xC4C4C4).CGColor
        rotate.duration = 3
        if round {
            rotate.beginTime = 0.25
        }
        rotate.repeatCount = 1_000_000
        rotate.autoreverses = true
        self.layer.addAnimation(rotate, forKey: "interpolate")
    }

}
