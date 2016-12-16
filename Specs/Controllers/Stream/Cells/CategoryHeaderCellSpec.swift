////
///  CategoryHeaderCellSpec.swift
//

@testable import Ello
import Quick
import Nimble
import Nimble_Snapshots
import PINRemoteImage
import PINCache

class CategoryHeaderCellSpec: QuickSpec {

    enum Style {
        case Narrow
        case Wide
        case iPad

        var width: CGFloat {
            switch self {
            case .Narrow: return 320
            case .Wide: return 375
            case .iPad: return 768
            }
        }
        func frame(height: CGFloat)  -> CGRect {
            return CGRect(x: 0, y: 0, width: self.width, height: height)
        }

    }

    override func spec() {

        describe("CategoryHeaderCell") {
            var subject: CategoryHeaderCell!

            func setImages() {
                subject.postedByAvatar.setImage(UIImage(named: "specs-avatar", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil), forState: .Normal)
                subject.setImage(UIImage(named: "specs-category-image.jpg", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)!)
            }

            describe("snapshots") {

                let shortBody = "Aliquam erat volutpat. Vestibulum ante."
                let longBody = "Nullam scelerisque pulvinar enim. Aliquam erat volutpat. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis eleifend lobortis sapien vitae ultrices. Interdum et malesuada fames ac ante ipsum primis in faucibus. Mauris interdum accumsan laoreet. Mauris sed massa est."
                let shortCtaCaption = "tap for more"
                let longCtaCaption = "tap for more and then you should do something else"

                let expectations: [
                    (String, type: StreamCellType, name: String, isSponsored: Bool, body: String, ctaCaption: String, style: Style)
                ] = [
                    ("category not sponsored, narrow", type: .CategoryPromotionalHeader, name: "A Longer Title Goes Here, does it wrap?", isSponsored: false, body: shortBody, ctaCaption: shortCtaCaption, style: .Narrow),
                    ("category not sponsored, wide", type: .CategoryPromotionalHeader, name: "Art", isSponsored: false, body: shortBody, ctaCaption: shortCtaCaption, style: .Wide),
                    ("category not sponsored, iPad", type: .CategoryPromotionalHeader, name: "Art", isSponsored: false, body: shortBody, ctaCaption: shortCtaCaption, style: .iPad),
                    ("category sponsored, narrow", type: .CategoryPromotionalHeader, name: "Art", isSponsored: true, body: shortBody, ctaCaption: shortCtaCaption, style: .Narrow),
                    ("category sponsored, wide", type: .CategoryPromotionalHeader, name: "Art", isSponsored: true, body: shortBody, ctaCaption: shortCtaCaption, style: .Wide),
                    ("category sponsored, iPad", type: .CategoryPromotionalHeader, name: "Art", isSponsored: true, body: shortBody, ctaCaption: shortCtaCaption, style: .iPad),
                    ("category long body, narrow", type: .CategoryPromotionalHeader, name: "Art", isSponsored: true, body: longBody, ctaCaption: shortCtaCaption, style: .Narrow),
                    ("category long body, wide", type: .CategoryPromotionalHeader, name: "Art", isSponsored: true, body: longBody, ctaCaption: shortCtaCaption, style: .Wide),
                    ("category long body, iPad", type: .CategoryPromotionalHeader, name: "Art", isSponsored: true, body: longBody, ctaCaption: shortCtaCaption, style: .iPad),
                    ("category long body, long cta caption, narrow", type: .CategoryPromotionalHeader, name: "Art", isSponsored: true, body: longBody, ctaCaption: longCtaCaption, style: .Narrow),
                    ("category long body, long cta caption, wide", type: .CategoryPromotionalHeader, name: "Art", isSponsored: true, body: longBody, ctaCaption: longCtaCaption, style: .Wide),
                    ("category long body, long cta caption, iPad", type: .CategoryPromotionalHeader, name: "Art", isSponsored: true, body: longBody, ctaCaption: longCtaCaption, style: .iPad),

                    ("page not sponsored, narrow", type: .PagePromotionalHeader, name: "A Longer Title Goes Here, does it wrap?", isSponsored: false, body: shortBody, ctaCaption: shortCtaCaption, style: .Narrow),
                    ("page not sponsored, wide", type: .PagePromotionalHeader, name: "Art", isSponsored: false, body: shortBody, ctaCaption: shortCtaCaption, style: .Wide),
                    ("page not sponsored, iPad", type: .PagePromotionalHeader, name: "Art", isSponsored: false, body: shortBody, ctaCaption: shortCtaCaption, style: .iPad),
                    ("page sponsored, narrow", type: .PagePromotionalHeader, name: "Art", isSponsored: true, body: shortBody, ctaCaption: shortCtaCaption, style: .Narrow),
                    ("page sponsored, wide", type: .PagePromotionalHeader, name: "Art", isSponsored: true, body: shortBody, ctaCaption: shortCtaCaption, style: .Wide),
                    ("page sponsored, iPad", type: .PagePromotionalHeader, name: "Art", isSponsored: true, body: shortBody, ctaCaption: shortCtaCaption, style: .iPad),
                    ("page long body, narrow", type: .PagePromotionalHeader, name: "Art", isSponsored: true, body: longBody, ctaCaption: shortCtaCaption, style: .Narrow),
                    ("page long body, wide", type: .PagePromotionalHeader, name: "Art", isSponsored: true, body: longBody, ctaCaption: shortCtaCaption, style: .Wide),
                    ("page long body, iPad", type: .PagePromotionalHeader, name: "Art", isSponsored: true, body: longBody, ctaCaption: shortCtaCaption, style: .iPad),
                    ("page long body, long cta caption, narrow", type: .PagePromotionalHeader, name: "Art", isSponsored: true, body: longBody, ctaCaption: longCtaCaption, style: .Narrow),
                    ("page long body, long cta caption, wide", type: .PagePromotionalHeader, name: "Art", isSponsored: true, body: longBody, ctaCaption: longCtaCaption, style: .Wide),
                    ("page long body, long cta caption, iPad", type: .PagePromotionalHeader, name: "Art", isSponsored: true, body: longBody, ctaCaption: longCtaCaption, style: .iPad)
                ]
                for (desc, type, name, isSponsored, body, ctaCaption, style) in expectations {

                    it("has valid screenshot for \(desc)") {

                        let user: User = User.stub(["id": "fakeuser", "username" : "bob"])
                        let xhdpi = Attachment.stub([
                            "url": "http://ello.co/avatar.png",
                            "height": 0,
                            "width": 0,
                            "type": "png",
                            "size": 0]
                        )
                        let image = Asset.stub(["xhdpi": xhdpi])
                        let promotional = Promotional.stub([
                            "user" : user,
                            "userId" : user.id,
                            "categoryId" : "888",
                            "id" : "999",
                            "image" : image
                        ])

                        let pagePromotional = PagePromotional.stub([
                            "id" : "abc",
                            "header" : name,
                            "user" : user,
                            "subheader" : body,
                            "ctaCaption" : ctaCaption,
                            "ctaURL" : "http://google.com",
                            "image" : image
                        ])

                        let category = Ello.Category.stub([
                            "id" : "888",
                            "name" : name,
                            "body" : body,
                            "user" : user,
                            "ctaCaption" : ctaCaption,
                            "isSponsored" : isSponsored,
                            "promotionals" : [promotional]
                        ])

                        if type == .CategoryPromotionalHeader {
                            let height = CategoryHeaderCellSizeCalculator.calculateCategoryHeight(category, cellWidth: style.width)
                            subject = CategoryHeaderCell(frame: style.frame(height))
                            let item = StreamCellItem(jsonable: category, type: .CategoryPromotionalHeader)
                            CategoryHeaderCellPresenter.configure(subject, streamCellItem: item, streamKind: .Category(slug: "Art"), indexPath: NSIndexPath(forItem: 0, inSection: 0), currentUser: nil)
                        }
                        else {
                            let height = CategoryHeaderCellSizeCalculator.calculatePagePromotionalHeight(pagePromotional, cellWidth: style.width)
                            subject = CategoryHeaderCell(frame: style.frame(height))
                            let item = StreamCellItem(jsonable: pagePromotional, type: .PagePromotionalHeader)
                            PagePromotionalHeaderCellPresenter.configure(subject, streamCellItem: item, streamKind: .Category(slug: "Design"), indexPath: NSIndexPath(forItem: 0, inSection: 0), currentUser: nil)
                        }
                        setImages()

                        subject.layoutIfNeeded()
                        showView(subject)
                        expect(subject).to(haveValidSnapshot())
                    }
                }
            }
        }
    }
}
