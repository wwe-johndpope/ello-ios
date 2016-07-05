extension UIWindow {
    class var mainWindow: UIWindow {
        return UIApplication.sharedApplication().keyWindow ?? UIWindow()
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


public class Window {
    static public var isWide: Bool { return UIWindow.mainWindow.frame.size.width > 1000 }
}
