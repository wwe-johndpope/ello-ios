////
///  CreateCommentBackgroundView.swift
//

public class CreateCommentBackgroundView: UIView {

    required override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = UIColor.clearColor()
    }

    override public func drawRect(rect: CGRect) {
        let color = UIColor.blackColor()
        let margin: CGFloat = 10
        let midY = self.frame.height / CGFloat(2)

        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        let radius: CGFloat = 5
        let π = CGFloat(M_PI)
        let corners = (
            tl: CGPoint(x: margin + radius, y: radius),
            tr: CGPoint(x: bounds.width - radius, y: radius),
            bl: CGPoint(x: margin + radius, y: bounds.height - radius),
            br: CGPoint(x: bounds.width - radius, y: bounds.height - radius)
        )

        bezierPath.moveToPoint(CGPoint(x: 0, y: midY))
        bezierPath.addLineToPoint(CGPoint(x: margin, y: midY - margin))
        bezierPath.addArcWithCenter(corners.tl, radius: radius, startAngle: -π, endAngle: -π / 2, clockwise: true)
        bezierPath.addArcWithCenter(corners.tr, radius: radius, startAngle: -π / 2, endAngle: 0, clockwise: true)
        bezierPath.addArcWithCenter(corners.br, radius: radius, startAngle: 0, endAngle: π / 2, clockwise: true)
        bezierPath.addArcWithCenter(corners.bl, radius: radius, startAngle: π / 2, endAngle: π, clockwise: true)
        bezierPath.addLineToPoint(CGPoint(x: margin, y: midY + margin))
        bezierPath.closePath()
        color.setFill()
        bezierPath.fill()
    }
}
