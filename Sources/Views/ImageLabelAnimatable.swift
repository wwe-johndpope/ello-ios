////
///  ImageLabelAnimatable.swift
//

@objc
protocol ImageLabelAnimatable {
    @objc optional func animate()
    @objc optional func finishAnimation()
    var isEnabled: Bool { get set }
    var isSelected: Bool { get set }
    var isHighlighted: Bool { get set }
    var view: UIView { get }
}
