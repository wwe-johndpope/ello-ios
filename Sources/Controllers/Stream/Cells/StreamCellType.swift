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
    case CategoryCard
    case SelectableCategoryCard
    case CategoryList
    case CategoryPromotionalHeader
    case CommentHeader
    case CreateComment
    case Embed(data: Regionable?)
    case Footer
    case Header
    case Image(data: Regionable?)
    case InviteFriends
    case OnboardingInviteFriends
    case EmptyStream(height: CGFloat)
    case NoPosts
    case Notification
    case PagePromotionalHeader
    case Announcement
    case Placeholder
    case ProfileHeader
    case ProfileHeaderGhost
    case Search(placeholder: String)
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
        case CategoryHeader
        case CategoryPosts
        case PeopleToFollow

        case Announcements
        case Notifications

        case ProfileHeader
        case ProfilePosts

        case PostCommentBar
        case PostComments
        case PostHeader
        case PostLovers
        case PostReposters
        case PostSocialPadding

        case CellNotFound
    }

    static let all = [
        CategoryCard,
        CategoryPromotionalHeader,
        SelectableCategoryCard,
        CategoryList,
        CommentHeader,
        CreateComment,
        Embed(data: nil),
        EmptyStream(height: 135),
        Footer,
        Header,
        Image(data: nil),
        InviteFriends,
        OnboardingInviteFriends,
        NoPosts,
        Notification,
        PagePromotionalHeader,
        Announcement,
        ProfileHeader,
        ProfileHeaderGhost,
        Search(placeholder: ""),
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
        case CategoryCard: return CategoryCardCell.reuseIdentifier
        case CategoryPromotionalHeader, PagePromotionalHeader: return CategoryHeaderCell.reuseIdentifier
        case SelectableCategoryCard: return CategoryCardCell.selectableReuseIdentifier
        case CategoryList: return CategoryListCell.reuseIdentifier
        case CommentHeader, Header: return StreamHeaderCell.reuseIdentifier
        case CreateComment: return StreamCreateCommentCell.reuseIdentifier
        case Embed: return StreamEmbedCell.reuseEmbedIdentifier
        case EmptyStream: return EmptyStreamCell.reuseEmbedIdentifier
        case Footer: return StreamFooterCell.reuseIdentifier
        case Image: return StreamImageCell.reuseIdentifier
        case InviteFriends, OnboardingInviteFriends: return StreamInviteFriendsCell.reuseIdentifier
        case NoPosts: return NoPostsCell.reuseIdentifier
        case Notification: return NotificationCell.reuseIdentifier
        case Placeholder: return "Placeholder"
        case Announcement: return AnnouncementCell.reuseIdentifier
        case ProfileHeader: return ProfileHeaderCell.reuseIdentifier
        case ProfileHeaderGhost: return ProfileHeaderGhostCell.reuseIdentifier
        case Search: return SearchStreamCell.reuseIdentifier
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
        case CategoryCard,
             SelectableCategoryCard,
             CreateComment,
             Header,
             InviteFriends,
             OnboardingInviteFriends,
             Notification,
             Announcement,
             SeeMoreComments,
             Toggle,
             UserListItem:
            return true
        default: return false
        }
    }

    public var configure: CellConfigClosure {
        switch self {
        case CategoryCard: return CategoryCardCellPresenter.configure
        case CategoryPromotionalHeader: return CategoryHeaderCellPresenter.configure
        case SelectableCategoryCard: return CategoryCardCellPresenter.configure
        case CategoryList: return CategoryListCellPresenter.configure
        case CommentHeader, Header: return StreamHeaderCellPresenter.configure
        case CreateComment: return StreamCreateCommentCellPresenter.configure
        case EmptyStream: return EmptyStreamCellPresenter.configure
        case Embed: return StreamEmbedCellPresenter.configure
        case Footer: return StreamFooterCellPresenter.configure
        case Image: return StreamImageCellPresenter.configure
        case InviteFriends, OnboardingInviteFriends: return StreamInviteFriendsCellPresenter.configure
        case NoPosts: return NoPostsCellPresenter.configure
        case Notification: return NotificationCellPresenter.configure
        case PagePromotionalHeader: return PagePromotionalHeaderCellPresenter.configure
        case Announcement: return AnnouncementCellPresenter.configure
        case ProfileHeader: return ProfileHeaderCellPresenter.configure
        case Search: return SearchStreamCellPresenter.configure
        case Spacer: return { (cell, _, _, _, _) in cell.backgroundColor = .whiteColor() }
        case FullWidthSpacer: return { (cell, _, _, _, _) in cell.backgroundColor = .whiteColor() }
        case StreamLoading: return StreamLoadingCellPresenter.configure
        case Text: return StreamTextCellPresenter.configure
        case TextHeader: return TextHeaderCellPresenter.configure
        case Toggle: return StreamToggleCellPresenter.configure
        case UserAvatars: return UserAvatarsCellPresenter.configure
        case UserListItem: return UserListItemCellPresenter.configure
        default: return { _ in }
        }
    }

    public var classType: UICollectionViewCell.Type {
        switch self {
        case CategoryPromotionalHeader, PagePromotionalHeader: return CategoryHeaderCell.self
        case CategoryCard: return CategoryCardCell.self
        case SelectableCategoryCard: return CategoryCardCell.self
        case CategoryList: return CategoryListCell.self
        case CommentHeader, Header: return StreamHeaderCell.self
        case CreateComment: return StreamCreateCommentCell.self
        case Embed: return StreamEmbedCell.self
        case EmptyStream: return EmptyStreamCell.self
        case Footer: return StreamFooterCell.self
        case Image: return StreamImageCell.self
        case InviteFriends, OnboardingInviteFriends: return StreamInviteFriendsCell.self
        case NoPosts: return NoPostsCell.self
        case Notification: return NotificationCell.self
        case Placeholder: return UICollectionViewCell.self
        case Announcement: return AnnouncementCell.self
        case ProfileHeader: return ProfileHeaderCell.self
        case ProfileHeaderGhost: return ProfileHeaderGhostCell.self
        case Search: return SearchStreamCell.self
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
        case CategoryPromotionalHeader, PagePromotionalHeader:
            return 150
        case CategoryCard, SelectableCategoryCard:
            return 110
        case CategoryList:
            return CategoryListCell.Size.height
        case CommentHeader,
             InviteFriends,
             OnboardingInviteFriends,
             SeeMoreComments:
            return 60
        case CreateComment:
            return 75
        case let EmptyStream(height):
            return height
        case Footer:
            return 44
        case Header:
            return 70
        case NoPosts:
            return 215
        case Notification:
            return 117
        case Announcement:
            return 200
        case let Spacer(height):
            return height
        case let FullWidthSpacer(height):
            return height
        case Search:
            return 68
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
        case CategoryPromotionalHeader,
             CategoryList,
             CreateComment,
             FullWidthSpacer,
             InviteFriends,
             EmptyStream,
             OnboardingInviteFriends,
             NoPosts,
             Notification,
             PagePromotionalHeader,
             Announcement,
             ProfileHeader,
             ProfileHeaderGhost,
             Search,
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
            CategoryPromotionalHeader,
            CategoryCard,
            SelectableCategoryCard,
            CategoryList,
            CreateComment,
            EmptyStream(height: 135),
            FullWidthSpacer(height: 0.0),
            Notification,
            PagePromotionalHeader,
            Announcement,
            Placeholder,
            ProfileHeader,
            ProfileHeaderGhost,
            Search(placeholder: ""),
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
