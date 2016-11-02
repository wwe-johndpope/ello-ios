////
///  Promotional.swift
//

import SwiftyJSON

public let PromotionalVersion = 1

public final class Promotional: JSONAble {

    let id: String
    let userId: String
    let categoryId: String
    var image: Asset?

    public init(
        id: String,
        userId: String,
        categoryId: String
    ) {
        self.id = id
        self.userId = userId
        self.categoryId = categoryId
        super.init(version: PromotionalVersion)
    }

    public required init(coder: NSCoder) {
        let decoder = Coder(coder)
        id = decoder.decodeKey("id")
        userId = decoder.decodeKey("userId")
        categoryId = decoder.decodeKey("categoryId")
        image = decoder.decodeOptionalKey("image")
        super.init(coder: coder)
    }

    public override func encodeWithCoder(coder: NSCoder) {
        let encoder = Coder(coder)
        encoder.encodeObject(id, forKey: "id")
        encoder.encodeObject(userId, forKey: "userId")
        encoder.encodeObject(categoryId, forKey: "categoryId")
        encoder.encodeObject(image, forKey: "image")
        super.encodeWithCoder(coder)
    }

    override public class func fromJSON(data: [String: AnyObject]) -> JSONAble {
        let json = JSON(data)
        let id = json["id"].stringValue
        let userId = json["user_id"].stringValue
        let categoryId = json["category_id"].stringValue

        let image: Asset?
        if let imageJson = json["image"].object as? [String: AnyObject] {
            image = Asset.fromJSON(imageJson) as? Asset
        }
        else {
            image = nil
        }

        let promotional = Promotional(id: id, userId: userId, categoryId: categoryId)
        promotional.image = image

        return promotional
    }
}

extension Promotional: JSONSaveable {
    var uniqId: String? { return id }
}
