////
///  ScreenExtensions.swift
//

extension UIWindow {
    class var mainWindow: UIWindow {
        return UIApplication.shared.keyWindow ?? UIWindow()
    }

    class func windowBounds() -> CGRect {
        return mainWindow.bounds
    }

    class func windowSize() -> CGSize {
        return windowBounds().size
    }

    class func windowWidth() -> CGFloat {
        return windowSize().width
    }

    class func windowHeight() -> CGFloat {
        return windowSize().height
    }

}


class Window {
    static func isWide(_ width: CGFloat) -> Bool {
        return width > 1000
    }

    fileprivate static var _width: CGFloat?
    static var width: CGFloat {
        get {
            return Window._width ?? UIWindow.mainWindow.frame.size.width
        }
        set {
            if AppSetup.sharedState.isTesting {
                Window._width = newValue
            }
        }
    }
}
