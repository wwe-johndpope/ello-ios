////
///  StreamCellType.swift
//

import Foundation

public typealias CellConfigClosure = (
    cell: UICollectionViewCell,
    streamCellItem: StreamCellItem,
    streamKind: StreamKind,
    indexPath: NSIndexPath,
    currentUser: User?
) -> Void

// MARK: Equatable
public func == (lhs: StreamCellType, rhs: StreamCellType) -> Bool {
    return lhs.identifier == rhs.identifier
}

public enum StreamCellType: Equatable {
    case Category
    case CategoryCard
    case SelectableCategoryCard
    case SeeAllCategories
    case CategoryList
    case ColumnToggle
    case CommentHeader
    case CreateComment
    case Embed(data: Regionable?)
    case Footer
    case Header
    case Image(data: Regionable?)
    case InviteFriends
    case NoPosts
    case Notification
    case Placeholder
    case ProfileHeader
    case SeeMoreComments
    case Spacer(height: CGFloat)
    case FullWidthSpacer(height: CGFloat)
    case StreamLoading
    case Text(data: Regionable?)
    case TextHeader(NSAttributedString?)
    case Toggle
    case Unknown
    case UserAvatars
    case UserListItem

    public enum PlaceholderType {
        case CategoryList
        case PeopleToFollow

        case ProfileHeader
        case ProfilePosts

        case PostCommentBar
        case PostComments
        case PostHeader
        case PostLovers
        case PostReposters
        case PostSocialPadding
    }

    static let all = [
        Category, SeeAllCategories,
        CategoryCard,
        SelectableCategoryCard,
        CategoryList,
        ColumnToggle,
        CommentHeader,
        CreateComment,
        Embed(data: nil),
        Footer,
        Header,
        Image(data: nil),
        InviteFriends,
        NoPosts,
        Notification,
        ProfileHeader,
        SeeMoreComments,
        Spacer(height: 0.0),
        FullWidthSpacer(height: 0.0),
        Placeholder,
        StreamLoading,
        Text(data: nil),
        TextHeader(nil),
        Toggle,
        Unknown,
        UserAvatars,
        UserListItem
    ]

    public var data: Any? {
        switch self {
        case let Embed(data): return data
        case let Image(data): return data
        case let Text(data): return data
        case let TextHeader(data): return data
        default: return nil
        }
    }

    // this is just stupid...
    public var identifier: String {
        return "\(self)"
    }

    public var name: String {
        switch self {
        case Category, SeeAllCategories: return CategoryCell.reuseIdentifier
        case CategoryCard: return CategoryCardCell.reuseIdentifier
        case SelectableCategoryCard: return CategoryCardCell.selectableReuseIdentifier
        case CategoryList: return CategoryListCell.reuseIdentifier
        case ColumnToggle: return ColumnToggleCell.reuseIdentifier
        case CommentHeader, Header: return StreamHeaderCell.reuseIdentifier
        case CreateComment: return StreamCreateCommentCell.reuseIdentifier
        case Embed: return StreamEmbedCell.reuseEmbedIdentifier
        case Footer: return StreamFooterCell.reuseIdentifier
        case Image: return StreamImageCell.reuseIdentifier
        case InviteFriends: return StreamInviteFriendsCell.reuseIdentifier
        case NoPosts: return NoPostsCell.reuseIdentifier
        case Notification: return NotificationCell.reuseIdentifier
        case Placeholder: return "Placeholder"
        case ProfileHeader: return ProfileHeaderCell.reuseIdentifier
        case SeeMoreComments: return StreamSeeMoreCommentsCell.reuseIdentifier
        case Spacer: return "StreamSpacerCell"
        case FullWidthSpacer: return "StreamSpacerCell"
        case StreamLoading: return StreamLoadingCell.reuseIdentifier
        case Text: return StreamTextCell.reuseIdentifier
        case TextHeader: return TextHeaderCell.reuseIdentifier
        case Toggle: return StreamToggleCell.reuseIdentifier
        case Unknown: return "StreamUnknownCell"
        case UserAvatars: return UserAvatarsCell.reuseIdentifier
        case UserListItem: return UserListItemCell.reuseIdentifier
        }
    }

    public var selectable: Bool {
        switch self {
        case Category,
             CategoryCard,
             SelectableCategoryCard,
             SeeAllCategories,
             CreateComment,
             Header,
             InviteFriends,
             Notification,
             SeeMoreComments,
             Toggle,
             UserListItem:
            return true
        default: return false
        }
    }

    public var configure: CellConfigClosure {
        switch self {
        case Category: return CategoryCellPresenter.configure
        case CategoryCard: return CategoryCardCellPresenter.configure
        case SelectableCategoryCard: return CategoryCardCellPresenter.configure
        case SeeAllCategories: return SeeAllCategoriesCellPresenter.configure
        case CategoryList: return CategoryListCellPresenter.configure
        case ColumnToggle: return ColumnToggleCellPresenter.configure
        case CommentHeader, Header: return StreamHeaderCellPresenter.configure
        case CreateComment: return StreamCreateCommentCellPresenter.configure
        case Embed: return StreamEmbedCellPresenter.configure
        case Footer: return StreamFooterCellPresenter.configure
        case Image: return StreamImageCellPresenter.configure
        case InviteFriends: return StreamInviteFriendsCellPresenter.configure
        case NoPosts: return NoPostsCellPresenter.configure
        case Notification: return NotificationCellPresenter.configure
        case ProfileHeader: return ProfileHeaderCellPresenter.configure
        case Spacer: return { (cell, _, _, _, _) in cell.backgroundColor = .whiteColor() }
        case FullWidthSpacer: return { (cell, _, _, _, _) in cell.backgroundColor = .whiteColor() }
        case StreamLoading: return StreamLoadingCellPresenter.configure
        case Text: return StreamTextCellPresenter.configure
        case TextHeader: return TextHeaderCellPresenter.configure
        case Toggle: return StreamToggleCellPresenter.configure
        case Unknown: return ProfileHeaderCellPresenter.configure
        case UserAvatars: return UserAvatarsCellPresenter.configure
        case UserListItem: return UserListItemCellPresenter.configure
        default: return { _ in }
        }
    }

    public var classType: UICollectionViewCell.Type {
        switch self {
        case Category, SeeAllCategories: return CategoryCell.self
        case CategoryCard: return CategoryCardCell.self
        case SelectableCategoryCard: return CategoryCardCell.self
        case CategoryList: return CategoryListCell.self
        case ColumnToggle: return ColumnToggleCell.self
        case CommentHeader, Header: return StreamHeaderCell.self
        case CreateComment: return StreamCreateCommentCell.self
        case Embed: return StreamEmbedCell.self
        case Footer: return StreamFooterCell.self
        case Image: return StreamImageCell.self
        case InviteFriends: return StreamInviteFriendsCell.self
        case NoPosts: return NoPostsCell.self
        case Notification: return NotificationCell.self
        case Placeholder: return UICollectionViewCell.self
        case ProfileHeader: return ProfileHeaderCell.self
        case SeeMoreComments: return StreamSeeMoreCommentsCell.self
        case StreamLoading: return StreamLoadingCell.self
        case Text: return StreamTextCell.self
        case TextHeader: return TextHeaderCell.self
        case Toggle: return StreamToggleCell.self
        case Unknown, Spacer, FullWidthSpacer: return UICollectionViewCell.self
        case UserAvatars: return UserAvatarsCell.self
        case UserListItem: return UserListItemCell.self
        }
    }

    public var oneColumnHeight: CGFloat {
        switch self {
        case Category, SeeAllCategories:
            return 56
        case CategoryCard, SelectableCategoryCard:
            return 110
        case CategoryList:
            return 66
        case ColumnToggle:
            return 40
        case CommentHeader,
             InviteFriends,
             SeeMoreComments:
            return 60
        case CreateComment:
            return 75
        case Footer:
            return 44
        case Header:
            return 70
        case NoPosts:
            return 215
        case Notification:
            return 117
        case let Spacer(height):
            return height
        case let FullWidthSpacer(height):
            return height
        case StreamLoading,
             UserAvatars:
            return 50
        case TextHeader:
            return 75
        case Toggle:
            return 40
        case UserListItem:
            return 85
        default: return 0
        }
    }

    public var multiColumnHeight: CGFloat {
        switch self {
        case Header,
            Notification:
            return 60
        default:
            return oneColumnHeight
        }
    }

    public var isFullWidth: Bool {
        switch self {
        case Category,
             SeeAllCategories,
             CategoryList,
             ColumnToggle,
             CreateComment,
             FullWidthSpacer,
             InviteFriends,
             NoPosts,
             Notification,
             ProfileHeader,
             SeeMoreComments,
             StreamLoading,
             TextHeader,
             UserAvatars,
             UserListItem:
            return true
        case CategoryCard,
             SelectableCategoryCard,
             CommentHeader,
             Embed,
             Footer,
             Header,
             Image,
             Placeholder,
             Spacer,
             Text,
             Toggle,
             Unknown:
            return false
        }
    }

    public var collapsable: Bool {
        switch self {
        case Image, Text, Embed: return true
        default: return false
        }
    }

    static func registerAll(collectionView: UICollectionView) {
        let noNibTypes = [
            Category,
            SeeAllCategories,
            CategoryCard,
            SelectableCategoryCard,
            CategoryList,
            CreateComment,
            FullWidthSpacer(height: 0.0),
            Notification,
            Placeholder,
            Spacer(height: 0.0),
            StreamLoading,
            TextHeader(nil),
            Unknown
        ]
        for type in all {
            if noNibTypes.indexOf(type) != nil {
                collectionView.registerClass(type.classType, forCellWithReuseIdentifier: type.name)
            } else {
                let nib = UINib(nibName: type.name, bundle: NSBundle(forClass: type.classType))
                collectionView.registerNib(nib, forCellWithReuseIdentifier: type.name)
            }
        }
    }
}
