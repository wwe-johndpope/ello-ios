////
///  UIImageViewExtensions.swift
//

extension UIImageView {
    var interfaceImage: InterfaceImage? {
        get { return nil }
        set { setInterfaceImage(newValue!, style: .normal) }
    }

    func setInterfaceImage(_ interfaceImage: InterfaceImage, style: InterfaceImage.Style) {
        self.image = interfaceImage.image(style)
    }

}
