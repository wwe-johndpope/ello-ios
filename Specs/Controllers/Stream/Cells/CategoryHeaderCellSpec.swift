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

        func frame(height: CGFloat)  -> CGRect {
            switch self {
            case .Narrow: return CGRect(x: 0, y: 0, width: 320, height: height)
            case .Wide: return CGRect(x: 0, y: 0, width: 375, height: height)
            case .iPad: return CGRect(x: 0, y: 0, width: 768, height: height)
            }
        }

    }

    override func spec() {

        fdescribe("CategoryHeaderCell") {

            var subject: CategoryHeaderCell!

            let user: User = User.stub(["id": "fakeuser", "username" : "bob"])
            let promotional: Promotional = Promotional.stub(["user": user, "id" : "999"])
            let category = Ello.Category.stub(
                [
                    "name" : "Art",
                    "body" : "This is a standard, pretty short category body.",
                    "user" : user,
                    "isSponsored" : true,
                    "promotionals" : [promotional]
                ]
            )

            func setImages() {
                subject.postedByAvatar.setImage(UIImage(named: "specs-avatar", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil), forState: .Normal)
                subject.setImage(UIImage(named: "specs-category-image.jpg", inBundle: NSBundle(forClass: self.dynamicType), compatibleWithTraitCollection: nil)!)
            }

            describe("snapshots") {
                let expectations: [
                    (String, type: StreamCellType, category: Ello.Category, isSponsored: Bool, ctaCaption: String, style: Style)
                ] = [
                    ("non promotional", type: .CategoryPromotionalHeader, category: category, isSponsored: false, ctaCaption: "tap for more", style: .Narrow)
                ]
                for (desc, type, category, isSponsored, ctaCaption) in expectations {
                    category.isSponsored = isSponsored
                    category.ctaCaption = ctaCaption

                    subject = CategoryHeaderCell(frame: .Zero)

                    if type == .CategoryPromotionalHeader {
                        let item = StreamCellItem(jsonable: category, type: .CategoryPromotionalHeader)
                        let height = CategoryHeaderCellSizeCalculator()
                        CategoryHeaderCellPresenter.configure(subject, streamCellItem: item, streamKind: .Category(slug: "Art"), indexPath: NSIndexPath(forItem: 0, inSection: 0), currentUser: nil)
                    }
                    else {
                        let item = StreamCellItem(jsonable: category, type: .PagePromotionalHeader)
                        PagePromotionalHeaderCellPresenter.configure(subject, streamCellItem: item, streamKind: .Category(slug: "Design"), indexPath: NSIndexPath(forItem: 0, inSection: 0), currentUser: nil)
                    }

                    it("has valid screenshot for \(desc)") {
                        subject.layoutIfNeeded()
                        showView(subject)
                        expect(subject).to(recordSnapshot())
                    }
                }
            }

            xcontext("Category Promotional") {

                beforeEach {
                    let frame = CGRect(origin: .zero, size: CGSize(width: 320, height: 66))
                    subject = CategoryHeaderCell(frame: frame)

                    let user: User = User.stub(["id": "fakeuser", "username" : "bob"])
                    let promotional: Promotional = Promotional.stub(["user": user, "id" : "999"])
                    let category = Ello.Category.stub(
                        [
                            "name" : "Art",
                            "body" : "This is a standard, pretty short category body.",
                            "user" : user,
                            "isSponsored" : true,
                            "promotionals" : [promotional]
                        ]
                    )
                    let item: StreamCellItem = StreamCellItem(jsonable: category, type: .CategoryPromotionalHeader)
                    CategoryHeaderCellPresenter.configure(subject, streamCellItem: item, streamKind: .Category(slug: "Art"), indexPath: NSIndexPath(forItem: 0, inSection: 0), currentUser: nil)
                }

                describe("snapshots") {
                    it("renders sponsored correctly") {
                        setImages()
                        expectValidSnapshot(subject, device: .Phone6_Portrait, record: true)
                    }
                }
            }

            context("Page Promotional") {

            }

        }
    }
}
