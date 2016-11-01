@testable import Ello
import Quick
import Nimble


class ProfileHeaderCellPresenterSpec: QuickSpec {
    override func spec() {
        describe("configure") {

            context("no user") {
                it("can still configure") {
                    let cell: ProfileHeaderCell = ProfileHeaderCell()
                    let item: StreamCellItem = StreamCellItem(type: .ProfileHeader)

                    expect {
                        ProfileHeaderCellPresenter.configure(cell, streamCellItem: item, streamKind: .CurrentUserStream, indexPath: NSIndexPath(forItem: 0, inSection: 0), currentUser: nil)
                    } .notTo(raiseException())
                }
            }

            context("no bio or links") {
                it("hides the stats gray line") {
                    let user: User = stub([:])
                    let cell: ProfileHeaderCell = ProfileHeaderCell()
                    let item: StreamCellItem = StreamCellItem(jsonable: user, type: .ProfileHeader)
                    item.calculatedCellHeights.profileBio = 0
                    item.calculatedCellHeights.profileLinks = 0

                    ProfileHeaderCellPresenter.configure(cell, streamCellItem: item, streamKind: .CurrentUserStream, indexPath: NSIndexPath(forItem: 0, inSection: 0), currentUser: nil)
                    expect(cell.statsView.grayLineVisible) == false
                }
            }

            context("no links") {
                it("hides the bio gray line") {
                    let user: User = stub([:])
                    let cell: ProfileHeaderCell = ProfileHeaderCell()
                    let item: StreamCellItem = StreamCellItem(jsonable: user, type: .ProfileHeader)
                    item.calculatedCellHeights.profileBio = 10
                    item.calculatedCellHeights.profileLinks = 0

                    ProfileHeaderCellPresenter.configure(cell, streamCellItem: item, streamKind: .CurrentUserStream, indexPath: NSIndexPath(forItem: 0, inSection: 0), currentUser: nil)
                    expect(cell.bioView.grayLineVisible) == false
                }
            }
        }
    }
}
