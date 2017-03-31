////
///  UIImageViewExtensions.swift
//

extension UIImageView {
    var interfaceImage: InterfaceImage? {
        get { return nil }
        set { setInterfaceImage(newValue!, style: .normal) }
    }

    func setInterfaceImage(_ interfaceImage: InterfaceImage, style: InterfaceImage.Style, degree: Double = 0) {
        self.image = interfaceImage.image(style)
        if degree != 0 {
            let radians = (degree * Double.pi) / 180.0
            self.transform = CGAffineTransform(rotationAngle: CGFloat(radians))
        }
    }

}
