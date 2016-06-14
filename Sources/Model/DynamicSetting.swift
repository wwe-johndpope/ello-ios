//
//  DynamicSetting.swift
//  Ello
//
//  Created by Tony DiPasquale on 4/10/15.
//  Copyright (c) 2015 Ello. All rights reserved.
//

import Crashlytics
import SwiftyJSON

let DynamicSettingVersion = 1
let DynamicSetAnotherVersion = 1

@objc(DynamicSetAnother)
public final class DynamicSetAnother: JSONAble {
    public let when: Bool?
    public let key: String
    public let value: Bool

    public required init(when: Bool?, key: String, value: Bool) {
        self.when = when
        self.key = key
        self.value = value
        super.init(version: DynamicSetAnotherVersion)
    }

    public required init(coder: NSCoder) {
        let decoder = Coder(coder)
        self.when = decoder.decodeOptionalKey("when")
        self.key = decoder.decodeKey("key")
        self.value = decoder.decodeKey("value")
        super.init(coder: coder)
    }

    public override func encodeWithCoder(coder: NSCoder) {
        let encoder = Coder(coder)
        if let when = when {
            encoder.encodeObject(when, forKey: "when")
        }
        encoder.encodeObject(key, forKey: "key")
        encoder.encodeObject(value, forKey: "value")
        super.encodeWithCoder(coder)
    }

    public override class func fromJSON(data: [String: AnyObject], fromLinked: Bool = false) -> JSONAble {
        let json = JSON(data)
        let when: Bool? = json["when"].bool
        let key: String = json["key"].stringValue
        let value: Bool = json["value"].boolValue
        return DynamicSetAnother(when: when, key: key, value: value)
    }

}

@objc(DynamicSetting)
public final class DynamicSetting: JSONAble {
    public let label: String
    public let key: String
    public let dependentOn: [String]
    public let conflictsWith: [String]
    public let setsAnother: [DynamicSetAnother]
    public let info: String?
    public let linkLabel: String?
    public let linkURL: NSURL?

    public init(label: String, key: String, dependentOn: [String], conflictsWith: [String], setsAnother: [DynamicSetAnother], info: String?, linkLabel: String?, linkURL: NSURL?) {
        self.label = label
        self.key = key
        self.dependentOn = dependentOn
        self.conflictsWith = conflictsWith
        self.setsAnother = setsAnother
        self.info = info
        self.linkLabel = linkLabel
        self.linkURL = linkURL
        super.init(version: DynamicSettingVersion)
    }

    public required init(coder aDecoder: NSCoder) {
        let decoder = Coder(aDecoder)
        self.label = decoder.decodeKey("label")
        self.key = decoder.decodeKey("key")
        self.dependentOn = decoder.decodeKey("dependentOn")
        self.conflictsWith = decoder.decodeKey("conflictsWith")
        self.setsAnother = decoder.decodeKey("setsAnother")
        self.info = decoder.decodeOptionalKey("info")
        self.linkLabel = decoder.decodeOptionalKey("linkLabel")
        self.linkURL = decoder.decodeOptionalKey("linkURL")
        super.init(coder: decoder.coder)
    }

    public override func encodeWithCoder(encoder: NSCoder) {
        let coder = Coder(encoder)
        coder.encodeObject(label, forKey: "label")
        coder.encodeObject(key, forKey: "key")
        coder.encodeObject(dependentOn, forKey: "dependentOn")
        coder.encodeObject(conflictsWith, forKey: "conflictsWith")
        coder.encodeObject(setsAnother, forKey: "setsAnother")
        coder.encodeObject(info, forKey: "info")
        coder.encodeObject(linkLabel, forKey: "linkLabel")
        coder.encodeObject(linkURL, forKey: "linkURL")
        super.encodeWithCoder(coder.coder)
    }

    public func sets(anotherSetting: DynamicSetting, when: Bool) -> Bool? {
        for dynamicSetAnother in setsAnother {
            if dynamicSetAnother.key == anotherSetting.key && (dynamicSetAnother.when == nil || dynamicSetAnother.when == when) {
                return dynamicSetAnother.value
            }
        }
        return nil
    }
}

extension DynamicSetting {
    public override class func fromJSON(data: [String: AnyObject], fromLinked: Bool = false) -> DynamicSetting {
        let json = JSON(data)
        Crashlytics.sharedInstance().setObjectValue(json.rawString(), forKey: CrashlyticsKey.DynamicSettingFromJSON.rawValue)
        let label = json["label"].stringValue
        let key = json["key"].stringValue

        let dependentOn: [String]
        if let jsonDependentOn = json["dependent_on"].array {
            dependentOn = jsonDependentOn.flatMap { $0.string }
        }
        else {
            dependentOn = []
        }

        let conflictsWith: [String]
        if let jsonConflictsWith = json["conflicts_with"].array {
            conflictsWith = jsonConflictsWith.flatMap { $0.string }
        }
        else {
            conflictsWith = []
        }

        let setsAnother: [DynamicSetAnother]
        if let jsonSetsAnother = json["sets_another"].array {
            setsAnother = jsonSetsAnother.flatMap { json in
                if let val = json.object as? [String: AnyObject] {
                    return DynamicSetAnother.fromJSON(val) as? DynamicSetAnother
                }
                return nil
            }
        }
        else {
            setsAnother = []
        }

        let info = json["info"].string
        let linkLabel = json["link"]["label"].string
        let linkURL = json["link"]["url"].URL

        return DynamicSetting(label: label, key: key, dependentOn: dependentOn, conflictsWith: conflictsWith, setsAnother: setsAnother, info: info, linkLabel: linkLabel, linkURL: linkURL)
    }
}

public extension DynamicSetting {
    static var blockedSetting: DynamicSetting {
        let label = InterfaceString.Settings.BlockedTitle
        let info = InterfaceString.Settings.BlockedTitle
        return DynamicSetting(label: label, key: "delete_account", dependentOn: [], conflictsWith: [], setsAnother: [], info: info, linkLabel: .None, linkURL: .None)
    }
    static var mutedSetting: DynamicSetting {
        let label = InterfaceString.Settings.MutedTitle
        let info = InterfaceString.Settings.MutedTitle
        return DynamicSetting(label: label, key: "delete_account", dependentOn: [], conflictsWith: [], setsAnother: [], info: info, linkLabel: .None, linkURL: .None)
    }
    static var accountDeletionSetting: DynamicSetting {
        let label = InterfaceString.Settings.DeleteAccount
        let info = InterfaceString.Settings.DeleteAccountExplanation
        return DynamicSetting(label: label, key: "delete_account", dependentOn: [], conflictsWith: [], setsAnother: [], info: info, linkLabel: .None, linkURL: .None)
    }
}
