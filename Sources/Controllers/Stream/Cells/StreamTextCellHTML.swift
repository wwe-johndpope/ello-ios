////
///  StreamTextCellHTML.swift
//

import Foundation

public struct StreamTextCellHTML {

    static var indexFile: String?

    public static func indexFileAsString() -> String {
        if let indexFile = StreamTextCellHTML.indexFile {
            return indexFile
        }
        else {
            let indexHTML = NSBundle.mainBundle().pathForResource("index", ofType: "html", inDirectory: "www")!

            var error: NSError?
            let indexAsText: NSString?
            do {
                indexAsText = try NSString(contentsOfFile: indexHTML, encoding: NSUTF8StringEncoding)
            } catch let error1 as NSError {
                error = error1
                indexAsText = nil
            }
            if error == nil && indexAsText != nil {
                if let indexAsSwiftString = indexAsText as? String {
                    StreamTextCellHTML.indexFile = indexAsSwiftString
                }
            }
            else {
                StreamTextCellHTML.indexFile = ""
            }
            return StreamTextCellHTML.indexFile!
        }
    }

    public static func postHTML(string: String) -> String {
        let htmlString = StreamTextCellHTML.indexFileAsString().stringByReplacingOccurrencesOfString("{{base-url}}", withString: ElloURI.baseURL)
        return htmlString.stringByReplacingOccurrencesOfString("{{post-content}}", withString: string)
    }
}
