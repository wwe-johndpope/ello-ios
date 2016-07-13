////
///  CryptoStringExtensions.swift
//

import Foundation
import Keys


public extension String {

    var saltedSHA1String: String? {
        let salt = ElloKeys().salt()
        return (salt + self).SHA1String
    }

    var SHA1String: String? {
        if let data = self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {

            var digest = [UInt8](count: Int(CC_SHA1_DIGEST_LENGTH), repeatedValue: 0)
            CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
            let output = NSMutableString(capacity: Int(CC_SHA512_DIGEST_LENGTH))
            for byte in digest {
                output.appendFormat("%02x", byte)
            }

            return output as String
        }
        return .None
    }

}
