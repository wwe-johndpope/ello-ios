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
                oneColumnHeight: CGFloat,
                multiColumnHeight: CGFloat,
                isFullWidth: Bool,
                collapsable: Bool)] = [
                    ("CategoryCard", type: .CategoryCard, name: CategoryCardCell.reuseIdentifier, selectable: true, classType: CategoryCardCell.self, oneColumnHeight: 110, multiColumnHeight: 110, isFullWidth: false, collapsable: false),
                    ("SelectableCategoryCard", type: .SelectableCategoryCard, name: CategoryCardCell.selectableReuseIdentifier, selectable: true,classType: CategoryCardCell.self, oneColumnHeight: 110, multiColumnHeight: 110, isFullWidth: false, collapsable: false),
                    ("CategoryList", type: .CategoryList, name: CategoryListCell.reuseIdentifier, selectable: false, classType: CategoryListCell.self, oneColumnHeight: 45, multiColumnHeight: 45, isFullWidth: true, collapsable: false),
                    ("CategoryPromotionalHeader", type: .CategoryPromotionalHeader, name: CategoryHeaderCell.reuseIdentifier, selectable: false,classType: CategoryHeaderCell.self, oneColumnHeight: 150, multiColumnHeight: 150, isFullWidth: true, collapsable: false),
                    ("CommentHeader", type: .CommentHeader, name: StreamHeaderCell.reuseIdentifier, selectable: false,classType: StreamHeaderCell.self, oneColumnHeight: 60, multiColumnHeight: 60, isFullWidth: false, collapsable: false),
                    ("CreateComment", type: .CreateComment, name: StreamCreateCommentCell.reuseIdentifier, selectable: true,classType: StreamCreateCommentCell.self, oneColumnHeight: 75, multiColumnHeight: 75, isFullWidth: true, collapsable: false),
                    ("Embed", type: .Embed(data: nil), name: StreamEmbedCell.reuseEmbedIdentifier, selectable: false,classType: StreamEmbedCell.self, oneColumnHeight: 0, multiColumnHeight: 0, isFullWidth: false, collapsable: true),
                    ("Footer", type: .Footer, name: StreamFooterCell.reuseIdentifier, selectable: false,classType: StreamFooterCell.self, oneColumnHeight: 44, multiColumnHeight: 44, isFullWidth: false, collapsable: false),
                    ("Header", type: .Header, name: StreamHeaderCell.reuseIdentifier, selectable: true,classType: StreamHeaderCell.self, oneColumnHeight: 70, multiColumnHeight: 60, isFullWidth: false, collapsable: false),
                    ("Image", type: .Image(data: nil), name: StreamImageCell.reuseIdentifier, selectable: false,classType: StreamImageCell.self, oneColumnHeight: 0, multiColumnHeight: 0, isFullWidth: false, collapsable: true),
                    ("InviteFriends", type: .InviteFriends, name: StreamInviteFriendsCell.reuseIdentifier, selectable: true,classType: StreamInviteFriendsCell.self, oneColumnHeight: 60, multiColumnHeight: 60, isFullWidth: true, collapsable: false),
                    ("OnboardingInviteFriends", type: .OnboardingInviteFriends, name: StreamInviteFriendsCell.reuseIdentifier, selectable: true,classType: StreamInviteFriendsCell.self, oneColumnHeight: 60, multiColumnHeight: 60, isFullWidth: true, collapsable: false),
                    ("EmptyStream", type: .EmptyStream(height: 135), name: EmptyStreamCell.reuseEmbedIdentifier, selectable: false,classType: EmptyStreamCell.self, oneColumnHeight: 135, multiColumnHeight: 135, isFullWidth: true, collapsable: false),
                    ("NoPosts", type: .NoPosts, name: NoPostsCell.reuseIdentifier, selectable: false,classType: NoPostsCell.self, oneColumnHeight: 215, multiColumnHeight: 215, isFullWidth: true, collapsable: false),
                    ("Notification", type: .Notification, name: NotificationCell.reuseIdentifier, selectable: true,classType: NotificationCell.self, oneColumnHeight: 117, multiColumnHeight: 60, isFullWidth: true, collapsable: false),
                    ("PagePromotionalHeader", type: .PagePromotionalHeader, name: CategoryHeaderCell.reuseIdentifier, selectable: false,classType: CategoryHeaderCell.self, oneColumnHeight: 150, multiColumnHeight: 150, isFullWidth: true, collapsable: false),
                    ("Placeholder", type: .Placeholder, name: "Placeholder", selectable: false,classType: UICollectionViewCell.self, oneColumnHeight: 0, multiColumnHeight: 0, isFullWidth: false, collapsable: false),
                    ("ProfileHeader", type: .ProfileHeader, name: ProfileHeaderCell.reuseIdentifier, selectable: false,classType: ProfileHeaderCell.self, oneColumnHeight: 0, multiColumnHeight: 0, isFullWidth: true, collapsable: false),
                    ("ProfileHeaderGhost", type: .ProfileHeaderGhost, name: ProfileHeaderGhostCell.reuseIdentifier, selectable: false,classType: ProfileHeaderGhostCell.self, oneColumnHeight: 0, multiColumnHeight: 0, isFullWidth: true, collapsable: false),
                    ("Search", type: .Search(placeholder: "cats"), name: SearchStreamCell.reuseIdentifier, selectable: false,classType: SearchStreamCell.self, oneColumnHeight: 68, multiColumnHeight: 68, isFullWidth: true, collapsable: false),
                    ("SeeMoreComments", type: .SeeMoreComments, name: StreamSeeMoreCommentsCell.reuseIdentifier, selectable: true,classType: StreamSeeMoreCommentsCell.self, oneColumnHeight: 60, multiColumnHeight: 60, isFullWidth: true, collapsable: false),
                    ("Spacer", type: .Spacer(height: 50), name: "StreamSpacerCell", selectable: false,classType: UICollectionViewCell.self, oneColumnHeight: 50, multiColumnHeight: 50, isFullWidth: false, collapsable: false),
                    ("FullWidthSpacer", type: .FullWidthSpacer(height: 125), name: "StreamSpacerCell", selectable: false,classType: UICollectionViewCell.self, oneColumnHeight: 125, multiColumnHeight: 125, isFullWidth: true, collapsable: false),
                    ("StreamLoading", type: .StreamLoading, name: StreamLoadingCell.reuseIdentifier, selectable: false,classType: StreamLoadingCell.self, oneColumnHeight: 50, multiColumnHeight: 50, isFullWidth: true, collapsable: false),
                    ("Text", type: .Text(data: nil), name: StreamTextCell.reuseIdentifier, selectable: false,classType: StreamTextCell.self, oneColumnHeight: 0, multiColumnHeight: 0, isFullWidth: false, collapsable: true),
                    ("TextHeader", type: .TextHeader(nil), name: TextHeaderCell.reuseIdentifier, selectable: false,classType: TextHeaderCell.self, oneColumnHeight: 75, multiColumnHeight: 75, isFullWidth: true, collapsable: false),
                    ("Toggle", type: .Toggle, name: StreamToggleCell.reuseIdentifier, selectable: true,classType: StreamToggleCell.self, oneColumnHeight: 40, multiColumnHeight: 40, isFullWidth: false, collapsable: false),
                    ("Unknown", type: .Unknown, name: "StreamUnknownCell", selectable: false,classType: UICollectionViewCell.self, oneColumnHeight: 0, multiColumnHeight: 0, isFullWidth: false, collapsable: false),
                    ("UserAvatars", type: .UserAvatars, name: UserAvatarsCell.reuseIdentifier, selectable: false,classType: UserAvatarsCell.self, oneColumnHeight: 50, multiColumnHeight: 50, isFullWidth: true, collapsable: false),
                    ("UserListItem", type: .UserListItem, name: UserListItemCell.reuseIdentifier, selectable: true,classType: UserListItemCell.self, oneColumnHeight: 85, multiColumnHeight: 85, isFullWidth: true, collapsable: false),
            ]

            for (desc, type, name, selectable, classType, oneColumnHeight, multiColumnHeight, isFullWidth, collapsable) in expectations {

                it("\(desc) returns correct values"){
                    // TODO: figure out a way to test for confgure
                    expect(type.name) == name
                    expect(type.selectable) == selectable
                    expect(type.classType) === classType
                    expect(type.oneColumnHeight) == oneColumnHeight
                    expect(type.multiColumnHeight) == multiColumnHeight
                    expect(type.isFullWidth) == isFullWidth
                    expect(type.collapsable) == collapsable
                }
            }
        }
    }
}

