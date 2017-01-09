////
///  Asset.swift
//

import Foundation
import SwiftyJSON


let AssetVersion = 1

@objc(Asset)
final class Asset: JSONAble {

    // active record
    let id: String
    // optional
    var optimized: Attachment?
    var smallScreen: Attachment?
    var ldpi: Attachment?
    var mdpi: Attachment?
    var hdpi: Attachment?
    var xhdpi: Attachment?
    var original: Attachment?
    // optional avatar
    var largeOrBest: Attachment? {
        // we originally had this expressed via
        // return large ?? optimized ?? xhdpi ?? hdpi ?? regular
        //
        // unfortunately that took 12.4 seconds to compile
        // this (much more verbose) code compiles very quickly
        if let large = large { return large }
        if let optimized = optimized { return optimized }
        if let xhdpi = xhdpi { return xhdpi }
        if let hdpi = hdpi { return hdpi }
        if let regular = regular { return regular }
        return nil

    }
    var large: Attachment?
    var regular: Attachment?
    var small: Attachment?
    // computed
    var isGif: Bool {
        return self.optimized?.type == "image/gif"
    }
    var isLargeGif: Bool {
        if isGif {
            if let size = self.optimized?.size {
                return size >= 3_145_728
            }
        }
        return false
    }

	var oneColumnAttachment: Attachment? {
        return self.hdpi
    }

    var gridLayoutAttachment: Attachment? {
        let isWide = Window.isWide(Window.width)
        if isWide {
            return self.hdpi
        }
        else {
            return self.mdpi
        }
    }

// MARK: Initialization

    convenience init(url: URL) {
        self.init(id: UUID().uuidString)

        let attachment = Attachment(url: url)
        self.optimized = attachment
    }

    convenience init(url: URL, gifData: Data, posterImage: UIImage) {
        self.init(id: UUID().uuidString)

        let optimized = Attachment(url: url)
        optimized.type = "image/gif"
        optimized.size = gifData.count
        optimized.width = Int(posterImage.size.width)
        optimized.height = Int(posterImage.size.height)
        self.optimized = optimized

        let hdpi = Attachment(url: url)
        hdpi.width = Int(posterImage.size.width)
        hdpi.height = Int(posterImage.size.height)
        hdpi.image = posterImage
        self.hdpi = hdpi
    }

    convenience init(url: URL, image: UIImage) {
        self.init(id: UUID().uuidString)

        let optimized = Attachment(url: url)
        optimized.width = Int(image.size.width)
        optimized.height = Int(image.size.height)
        optimized.image = image

        self.optimized = optimized
    }

    init(id: String)
    {
        self.id = id
        super.init(version: AssetVersion)
    }

// MARK: NSCoding

    required init(coder aDecoder: NSCoder) {
        let decoder = Coder(aDecoder)
        // required
        self.id = decoder.decodeKey("id")
        // optional
        self.optimized = decoder.decodeOptionalKey("optimized")
        self.smallScreen = decoder.decodeOptionalKey("smallScreen")
        self.ldpi = decoder.decodeOptionalKey("ldpi")
        self.mdpi = decoder.decodeOptionalKey("mdpi")
        self.hdpi = decoder.decodeOptionalKey("hdpi")
        self.xhdpi = decoder.decodeOptionalKey("xhdpi")
        self.original = decoder.decodeOptionalKey("original")
        // optional avatar
        self.large = decoder.decodeOptionalKey("large")
        self.regular = decoder.decodeOptionalKey("regular")
        self.small = decoder.decodeOptionalKey("small")
        super.init(coder: decoder.coder)
    }

    override func encode(with encoder: NSCoder) {
        let coder = Coder(encoder)
        // required
        coder.encodeObject(id, forKey: "id")
        // optional
        coder.encodeObject(optimized, forKey: "optimized")
        coder.encodeObject(smallScreen, forKey: "smallScreen")
        coder.encodeObject(ldpi, forKey: "ldpi")
        coder.encodeObject(mdpi, forKey: "mdpi")
        coder.encodeObject(hdpi, forKey: "hdpi")
        coder.encodeObject(xhdpi, forKey: "xhdpi")
        coder.encodeObject(original, forKey: "original")
        // optional avatar
        coder.encodeObject(large, forKey: "large")
        coder.encodeObject(regular, forKey: "regular")
        coder.encodeObject(small, forKey: "small")
        super.encode(with: coder.coder)
    }

// MARK: JSONAble

    override class func fromJSON(_ data: [String: AnyObject]) -> JSONAble {
        let json = JSON(data)
        return parseAsset(json["id"].stringValue, node: data["attachment"] as? [String: AnyObject])
    }

    class func parseAsset(_ id: String, node: [String: AnyObject]?) -> Asset {
        let asset = Asset(id: id)
        // optional
        if let optimized = node?["optimized"] as? [String: AnyObject] {
            asset.optimized = Attachment.fromJSON(optimized) as? Attachment
        }
        if let smallScreen = node?["small_screen"] as? [String: AnyObject] {
            asset.smallScreen = Attachment.fromJSON(smallScreen) as? Attachment
        }
        if let ldpi = node?["ldpi"] as? [String: AnyObject] {
            asset.ldpi = Attachment.fromJSON(ldpi) as? Attachment
        }
        if let mdpi = node?["mdpi"] as? [String: AnyObject] {
            asset.mdpi = Attachment.fromJSON(mdpi) as? Attachment
        }
        if let hdpi = node?["hdpi"] as? [String: AnyObject] {
            asset.hdpi = Attachment.fromJSON(hdpi) as? Attachment
        }
        if let xhdpi = node?["xhdpi"] as? [String: AnyObject] {
            asset.xhdpi = Attachment.fromJSON(xhdpi) as? Attachment
        }
        if let original = node?["original"] as? [String: AnyObject] {
            asset.original = Attachment.fromJSON(original) as? Attachment
        }
        // optional avatar
        if let large = node?["large"] as? [String: AnyObject] {
            asset.large = Attachment.fromJSON(large) as? Attachment
        }
        if let regular = node?["regular"] as? [String: AnyObject] {
            asset.regular = Attachment.fromJSON(regular) as? Attachment
        }
        if let small = node?["small"] as? [String: AnyObject] {
            asset.small = Attachment.fromJSON(small) as? Attachment
        }
        return asset
    }
}

extension Asset: JSONSaveable {
    var uniqueId: String? { if let id = tableId { return "Asset-\(id)" } ; return nil }
    var tableId: String? { return id }

}
