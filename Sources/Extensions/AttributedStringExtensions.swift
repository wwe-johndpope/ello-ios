////
///  DictionaryExtensions.swift
//

import Foundation

extension NSAttributedString {
    func append(str: NSAttributedString) -> NSAttributedString {
        let retval: NSMutableAttributedString = NSMutableAttributedString(attributedString: self)
        retval.appendAttributedString(str)
        return NSAttributedString(attributedString: retval)
    }
}

func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    return left.append(right)
}
