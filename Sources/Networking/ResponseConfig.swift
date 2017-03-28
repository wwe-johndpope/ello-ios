////
///  ResponseConfig.swift
//

import Foundation

class ResponseConfig: CustomStringConvertible {
    var description: String {
        let descripArray = [
            "ResponseConfig:",
            "nextQueryItems: \(String(describing: nextQueryItems))",
            "prevQueryItems: \(String(describing: prevQueryItems))",
            "firstQueryItems: \(String(describing: firstQueryItems))",
            "lastQueryItems: \(String(describing: lastQueryItems))",
            "totalPages: \(String(describing: totalPages))",
            "totalCount: \(String(describing: totalCount))",
            "totalPagesRemaining: \(String(describing: totalPagesRemaining))"
        ]
        return descripArray.joined(separator: "\n\t")
    }
    var nextQueryItems: [AnyObject]? // before (older)
    var prevQueryItems: [AnyObject]? // after (newer)
    var firstQueryItems: [AnyObject]? // first page
    var lastQueryItems: [AnyObject]? // last page
    var totalCount: String?
    var totalPages: String?
    var totalPagesRemaining: String?
    var statusCode: Int?
    var lastModified: String?
    var isFinalValue: Bool

    init(isFinalValue: Bool = true) {
        self.isFinalValue = isFinalValue
    }

    func isOutOfData() -> Bool {

        return totalPagesRemaining == "0"
            || totalPagesRemaining == nil
            || nextQueryItems?.count == 0
            || nextQueryItems == nil
    }
}
