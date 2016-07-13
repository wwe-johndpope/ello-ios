////
///  UIImageViewExtensions.swift
//

extension UIImageView {

    func setImage(interfaceImage: InterfaceImage, degree: Double) {
        self.image = interfaceImage.normalImage
        if degree != 0 {
            let radians = (degree * M_PI) / 180.0
            self.transform = CGAffineTransformMakeRotation(CGFloat(radians))
        }
    }

}
