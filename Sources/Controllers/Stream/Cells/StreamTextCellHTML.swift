////
///  StreamTextCellHTML.swift
//

import Foundation

struct StreamTextCellHTML {

    static var indexFile: String?

    static func indexFileAsString() -> String {
        if let indexFile = StreamTextCellHTML.indexFile {
            return indexFile
        }
        else {
            let indexHTML = Bundle.main.path(forResource: "index", ofType: "html", inDirectory: "www")!

            var error: NSError?
            let indexAsText: NSString?
            do {
                indexAsText = try NSString(contentsOfFile: indexHTML, encoding: String.Encoding.utf8.rawValue)
            } catch let error1 as NSError {
                error = error1
                indexAsText = nil
            }
            if let indexAsText = indexAsText, error == nil {
                StreamTextCellHTML.indexFile = indexAsText as String
            }
            else {
                StreamTextCellHTML.indexFile = ""
            }
            return StreamTextCellHTML.indexFile!
        }
    }

    static func postHTML(_ string: String) -> String {
        let htmlString = StreamTextCellHTML.indexFileAsString().replacingOccurrences(of: "{{base-url}}", with: ElloURI.baseURL)
        return htmlString.replacingOccurrences(of: "{{post-content}}", with: string)
    }
}
