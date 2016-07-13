////
///  ImageLabelAnimatable.swift
//

@objc
public protocol ImageLabelAnimatable {
    optional func animate()
    optional func finishAnimation()
    var enabled: Bool { get set }
    var selected: Bool { get set }
    var highlighted: Bool { get set }
    var view: UIView { get }
}
