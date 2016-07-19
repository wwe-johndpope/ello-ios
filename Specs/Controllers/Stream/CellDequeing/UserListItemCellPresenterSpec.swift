////
///  UserListItemCellPresenterSpec.swift
//

import Ello
import Quick
import Nimble

class UserListItemCellPresenterSpec: QuickSpec {

    override func spec() {

        describe("configure") {

            it("sets the relationship priority and username") {
                let cell: UserListItemCell = UserListItemCell.loadFromNib()
                let user: User = stub([
                    "relationshipPriority": "friend",
                    "username": "sterling_archer"
                    ])
                let item = StreamCellItem(jsonable: user, type: .UserListItem)

                UserListItemCellPresenter.configure(cell, streamCellItem: item, streamKind: StreamKind.UserStream(userParam: user.id), indexPath: NSIndexPath(forItem: 0, inSection: 0), currentUser: nil)

                expect(cell.relationshipControl.relationshipPriority) == RelationshipPriority.Following
                expect(cell.usernameLabel.text) == "@sterling_archer"
            }

        }

    }
}
