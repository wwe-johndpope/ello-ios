////
///  AmazonCredentials.swift
//

import Crashlytics

let AmazonCredentialsVersion = 2

@objc(AmazonCredentials)
public class AmazonCredentials: JSONAble {
    public let accessKey: String
    public let endpoint: String
    public let policy: String
    public let prefix: String
    public let signature: String

    public init(accessKey: String, endpoint: String, policy: String, prefix: String, signature: String) {
        self.accessKey = accessKey
        self.endpoint = endpoint
        self.policy = policy
        self.prefix = prefix
        self.signature = signature
        super.init(version: AmazonCredentialsVersion)
    }

    public required init(coder aDecoder: NSCoder) {
        let decoder = Coder(aDecoder)
        let version: Int = decoder.decodeKey("version")
        if version > 1 {
            accessKey = decoder.decodeKey("accessKey")
            endpoint = decoder.decodeKey("endpoint")
            policy = decoder.decodeKey("policy")
            prefix = decoder.decodeKey("prefix")
            signature = decoder.decodeKey("signature")
        }
        else {
            accessKey = ""
            endpoint = ""
            policy = ""
            prefix = ""
            signature = ""
        }
        super.init(coder: aDecoder)
    }

    public override func encodeWithCoder(encoder: NSCoder) {
        let coder = Coder(encoder)
        coder.encodeObject(accessKey, forKey: "accessKey")
        coder.encodeObject(endpoint, forKey: "endpoint")
        coder.encodeObject(policy, forKey: "policy")
        coder.encodeObject(prefix, forKey: "prefix")
        coder.encodeObject(signature, forKey: "signature")
    }

    override public class func fromJSON(data: [String : AnyObject]) -> JSONAble {
        Crashlytics.sharedInstance().setObjectValue(data.description, forKey: CrashlyticsKey.AmazonCredentialsFromJSON.rawValue)
        return AmazonCredentials(
            accessKey: data["access_key"] as! String,
            endpoint:  data["endpoint"] as! String,
            policy:    data["policy"] as! String,
            prefix:    data["prefix"] as! String,
            signature: data["signature"] as! String
        )
    }
}

extension AmazonCredentials: JSONSaveable {
    var uniqId: String? { return accessKey }
}
