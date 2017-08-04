////
///  MockUIWebView.swift
//

class MockUIWebView: UIWebView {
    var mockHeight: CGFloat = 50

    override func loadHTMLString(_ html: String, baseURL: URL?) {
        delegate?.webViewDidFinishLoad?(self)
    }

    override func stringByEvaluatingJavaScript(from js: String) -> String? {
        if js.contains("offsetWidth") { return "\(frame.size.width)" }
        if js.contains("offsetHeight") { return "\(mockHeight)" }
        return super.stringByEvaluatingJavaScript(from: js)
    }
}
