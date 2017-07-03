////
///  StreamCellTypeSpec.swift
//

@testable import Ello
import Quick
import Nimble


class StreamCellTypeSpec: QuickSpec {

    override func spec() {
        describe("StreamCellType") {

            let expectations: [(
                String,
                type: StreamCellType,
                name: String,
                selectable: Bool,
                classType: AnyClass,
                oneColumnHeight: CGFloat?,
                multiColumnHeight: CGFloat?,
                isFullWidth: Bool,
                collapsable: Bool)] = [
                    (".categoryCard", type: .categoryCard, name: CategoryCardCell.reuseIdentifier, selectable: true, classType: CategoryCardCell.self, oneColumnHeight: nil, multiColumnHeight: nil, isFullWidth: false, collapsable: false),
                    (".selectableCategoryCard", type: .selectableCategoryCard, name: CategoryCardCell.selectableReuseIdentifier, selectable: true, classType: CategoryCardCell.self, oneColumnHeight: nil, multiColumnHeight: nil, isFullWidth: false, collapsable: false),
                    (".categoryList", type: .categoryList, name: CategoryListCell.reuseIdentifier, selectable: false, classType: CategoryListCell.self, oneColumnHeight: 45, multiColumnHeight: 45, isFullWidth: true, collapsable: false),
                    (".categoryPromotionalHeader", type: .categoryPromotionalHeader, name: CategoryHeaderCell.reuseIdentifier, selectable: false, classType: CategoryHeaderCell.self, oneColumnHeight: 150, multiColumnHeight: 150, isFullWidth: true, collapsable: false),
                    (".commentHeader", type: .commentHeader, name: StreamHeaderCell.reuseIdentifier, selectable: false, classType: StreamHeaderCell.self, oneColumnHeight: 60, multiColumnHeight: 60, isFullWidth: false, collapsable: false),
                    (".createComment", type: .createComment, name: StreamCreateCommentCell.reuseIdentifier, selectable: true, classType: StreamCreateCommentCell.self, oneColumnHeight: 75, multiColumnHeight: 75, isFullWidth: true, collapsable: false),
                    (".embed", type: .embed(data: nil), name: StreamEmbedCell.reuseEmbedIdentifier, selectable: false, classType: StreamEmbedCell.self, oneColumnHeight: 0, multiColumnHeight: 0, isFullWidth: false, collapsable: true),
                    (".editorial", type: .editorial(.post), name: Editorial.Kind.post.reuseIdentifier, selectable: false, classType: EditorialPostCell.self, oneColumnHeight: 376, multiColumnHeight: 376, isFullWidth: true, collapsable: false),
                    (".footer", type: .footer, name: StreamFooterCell.reuseIdentifier, selectable: false, classType: StreamFooterCell.self, oneColumnHeight: 44, multiColumnHeight: 44, isFullWidth: false, collapsable: false),
                    (".header", type: .header, name: StreamHeaderCell.reuseIdentifier, selectable: true, classType: StreamHeaderCell.self, oneColumnHeight: 70, multiColumnHeight: 60, isFullWidth: false, collapsable: false),
                    (".image", type: .image(data: nil), name: StreamImageCell.reuseIdentifier, selectable: false, classType: StreamImageCell.self, oneColumnHeight: 0, multiColumnHeight: 0, isFullWidth: false, collapsable: true),
                    (".inviteFriends", type: .inviteFriends, name: StreamInviteFriendsCell.reuseIdentifier, selectable: true, classType: StreamInviteFriendsCell.self, oneColumnHeight: 60, multiColumnHeight: 60, isFullWidth: true, collapsable: false),
                    (".onboardingInviteFriends", type: .onboardingInviteFriends, name: StreamInviteFriendsCell.reuseIdentifier, selectable: true, classType: StreamInviteFriendsCell.self, oneColumnHeight: 60, multiColumnHeight: 60, isFullWidth: true, collapsable: false),
                    (".emptyStream", type: .emptyStream(height: 282), name: EmptyStreamCell.reuseEmbedIdentifier, selectable: false, classType: EmptyStreamCell.self, oneColumnHeight: 282, multiColumnHeight: 282, isFullWidth: true, collapsable: false),
                    (".noPosts", type: .noPosts, name: NoPostsCell.reuseIdentifier, selectable: false, classType: NoPostsCell.self, oneColumnHeight: 215, multiColumnHeight: 215, isFullWidth: true, collapsable: false),
                    (".notification", type: .notification, name: NotificationCell.reuseIdentifier, selectable: true, classType: NotificationCell.self, oneColumnHeight: 117, multiColumnHeight: 60, isFullWidth: true, collapsable: false),
                    (".pagePromotionalHeader", type: .pagePromotionalHeader, name: CategoryHeaderCell.reuseIdentifier, selectable: false, classType: CategoryHeaderCell.self, oneColumnHeight: 150, multiColumnHeight: 150, isFullWidth: true, collapsable: false),
                    (".placeholder", type: .placeholder, name: "Placeholder", selectable: false, classType: UICollectionViewCell.self, oneColumnHeight: 0, multiColumnHeight: 0, isFullWidth: false, collapsable: false),
                    (".profileHeader", type: .profileHeader, name: ProfileHeaderCell.reuseIdentifier, selectable: false, classType: ProfileHeaderCell.self, oneColumnHeight: 0, multiColumnHeight: 0, isFullWidth: true, collapsable: false),
                    (".profileHeaderGhost", type: .profileHeaderGhost, name: ProfileHeaderGhostCell.reuseIdentifier, selectable: false, classType: ProfileHeaderGhostCell.self, oneColumnHeight: 0, multiColumnHeight: 0, isFullWidth: true, collapsable: false),
                    (".search", type: .search(placeholder: "cats"), name: SearchStreamCell.reuseIdentifier, selectable: false, classType: SearchStreamCell.self, oneColumnHeight: 68, multiColumnHeight: 68, isFullWidth: true, collapsable: false),
                    (".seeMoreComments", type: .seeMoreComments, name: StreamSeeMoreCommentsCell.reuseIdentifier, selectable: true, classType: StreamSeeMoreCommentsCell.self, oneColumnHeight: 60, multiColumnHeight: 60, isFullWidth: true, collapsable: false),
                    (".spacer", type: .spacer(height: 50), name: "StreamSpacerCell", selectable: false, classType: UICollectionViewCell.self, oneColumnHeight: 50, multiColumnHeight: 50, isFullWidth: false, collapsable: false),
                    (".fullWidthSpacer", type: .fullWidthSpacer(height: 125), name: "StreamSpacerCell", selectable: false, classType: UICollectionViewCell.self, oneColumnHeight: 125, multiColumnHeight: 125, isFullWidth: true, collapsable: false),
                    (".streamLoading", type: .streamLoading, name: StreamLoadingCell.reuseIdentifier, selectable: false, classType: StreamLoadingCell.self, oneColumnHeight: 50, multiColumnHeight: 50, isFullWidth: true, collapsable: false),
                    (".text", type: .text(data: nil), name: StreamTextCell.reuseIdentifier, selectable: false, classType: StreamTextCell.self, oneColumnHeight: 0, multiColumnHeight: 0, isFullWidth: false, collapsable: true),
                    (".textHeader", type: .textHeader(nil), name: TextHeaderCell.reuseIdentifier, selectable: false, classType: TextHeaderCell.self, oneColumnHeight: 75, multiColumnHeight: 75, isFullWidth: true, collapsable: false),
                    (".toggle", type: .toggle, name: StreamToggleCell.reuseIdentifier, selectable: true, classType: StreamToggleCell.self, oneColumnHeight: 40, multiColumnHeight: 40, isFullWidth: false, collapsable: false),
                    (".unknown", type: .unknown, name: "StreamUnknownCell", selectable: false, classType: UICollectionViewCell.self, oneColumnHeight: 0, multiColumnHeight: 0, isFullWidth: false, collapsable: false),
                    (".userAvatars", type: .userAvatars, name: UserAvatarsCell.reuseIdentifier, selectable: false, classType: UserAvatarsCell.self, oneColumnHeight: 50, multiColumnHeight: 50, isFullWidth: true, collapsable: false),
                    (".userListItem", type: .userListItem, name: UserListItemCell.reuseIdentifier, selectable: true, classType: UserListItemCell.self, oneColumnHeight: 85, multiColumnHeight: 85, isFullWidth: true, collapsable: false),
            ]

            for (desc, type, name, selectable, classType, oneColumnHeight, multiColumnHeight, isFullWidth, collapsable) in expectations {

                it("\(desc) returns correct values"){
                    // TODO: figure out a way to test for confgure
                    expect(type.reuseIdentifier) == name
                    expect(type.selectable) == selectable
                    expect(type.classType) === classType
                    if let oneColumnHeight = oneColumnHeight {
                        expect(type.oneColumnHeight) == oneColumnHeight
                    }
                    if let multiColumnHeight = multiColumnHeight {
                        expect(type.multiColumnHeight) == multiColumnHeight
                    }
                    expect(type.isFullWidth) == isFullWidth
                    expect(type.collapsable) == collapsable
                }
            }
        }
    }
}
