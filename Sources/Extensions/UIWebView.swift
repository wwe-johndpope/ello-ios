////
///  UIWebView.swift
//

public extension UIWebView {

    func windowContentSize() -> CGSize? {
        if let jsWidth = self.stringByEvaluatingJavaScriptFromString("(document.getElementById('post-container') || document.getElementByTagName('div')[0] || document.body).offsetWidth") {
            if let jsHeight = self.stringByEvaluatingJavaScriptFromString("window.contentHeight()") {
                let width = CGFloat((jsWidth as NSString).doubleValue)
                let height = CGFloat((jsHeight as NSString).doubleValue)
                return CGSize(width: width, height: height)
            }
        }
        return nil
    }
}
