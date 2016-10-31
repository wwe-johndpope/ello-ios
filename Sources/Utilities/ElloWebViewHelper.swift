////
///  ElloWebViewHelper.swift
//

public struct ElloWebViewHelper {
    static let jsCommandProtocol = "ello://"

    public static func handleRequest(request: NSURLRequest, webLinkDelegate: WebLinkDelegate?, fromWebView: Bool = false) -> Bool {
        let requestURL = request.URLString
        if requestURL.hasPrefix(jsCommandProtocol) {
            return false
        }
        else if requestURL.rangeOfString("(https?:\\/\\/|mailto:)", options: .RegularExpressionSearch) != nil {
            let (type, data) = ElloURI.match(requestURL)
            if type == .Email {
                if let url = NSURL(string: requestURL) {
                    UIApplication.sharedApplication().openURL(url)
                }
                return false
            }
            else {
                if fromWebView && type.loadsInWebViewFromWebView { return true }
                webLinkDelegate?.webLinkTapped(type, data: data)
                return false
            }
        }
        return true
    }

    public static func bypassInAppBrowser(url: NSURL?) -> Bool {
        guard let urlString = url?.absoluteString else { return false }

        if urlString =~ "(https?:\\/\\/appstore.com)" { return true }
        if urlString =~ "(https?:\\/\\/itunes.apple.com)" { return true }

        return false
    }
}
