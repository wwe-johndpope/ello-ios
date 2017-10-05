////
///  StreamCellType.swift
//

typealias CellConfigClosure = (
    _ cell: UICollectionViewCell,
    _ streamCellItem: StreamCellItem,
    _ streamKind: StreamKind,
    _ indexPath: IndexPath,
    _ currentUser: User?
) -> Void

// MARK: Equatable
func == (lhs: StreamCellType, rhs: StreamCellType) -> Bool {
    return lhs.equalityIdentifier == rhs.equalityIdentifier
}

enum StreamCellType: Equatable {
    case announcement
    case artistInviteAdminControls
    case artistInviteBubble
    case artistInviteControls
    case artistInviteGuide(ArtistInvite.Guide?)
    case artistInviteHeader
    case artistInviteSubmissionsButton
    case badge
    case categoryCard
    case categoryList
    case categoryPromotionalHeader
    case commentHeader
    case createComment
    case editorial(Editorial.Kind)
    case embed(data: Regionable?)
    case emptyStream(height: CGFloat)
    case fullWidthSpacer(height: CGFloat)
    case header(NSAttributedString?)
    case image(data: Regionable?)
    case inviteFriends
    case loadMoreComments
    case noPosts
    case notification
    case onboardingInviteFriends
    case pagePromotionalHeader
    case placeholder
    case profileHeader
    case profileHeaderGhost
    case revealController(label: String, Any)
    case search(placeholder: String)
    case seeMoreComments
    case selectableCategoryCard
    case spacer(height: CGFloat)
    case spinner(height: CGFloat)
    case streamFooter
    case streamHeader
    case streamLoading
    case tallHeader(NSAttributedString?)
    case text(data: Regionable?)
    case toggle
    case unknown
    case userAvatars
    case userListItem

    enum PlaceholderType {
        case streamPosts

        case categoryList
        case categoryHeader
        case peopleToFollow

        case announcements
        case notifications

        case editorials
        case artistInvites
        case artistInviteSubmissionsButton
        case artistInviteDetails
        case artistInviteAdmin
        case artistInviteSubmissionsHeader

        case profileHeader

        case postCommentBar
        case postComments
        case postLoadingComments
        case postHeader
        case postLovers
        case postReposters
        case postSocialPadding
        case postRelatedPosts

        case cellNotFound
    }

    static let all: [StreamCellType] = [
        .announcement,
        .artistInviteBubble,
        .artistInviteAdminControls,
        .artistInviteControls,
        .artistInviteGuide(nil),
        .artistInviteHeader,
        .artistInviteSubmissionsButton,
        .badge,
        .categoryCard,
        .categoryList,
        .categoryPromotionalHeader,
        .commentHeader,
        .createComment,
        .editorial(.external),
        .editorial(.internal),
        .editorial(.invite),
        .editorial(.join),
        .editorial(.post),
        .editorial(.postStream),
        .embed(data: nil),
        .emptyStream(height: 282),
        .fullWidthSpacer(height: 0),
        .header(nil),
        .image(data: nil),
        .inviteFriends,
        .loadMoreComments,
        .noPosts,
        .notification,
        .onboardingInviteFriends,
        .pagePromotionalHeader,
        .placeholder,
        .profileHeader,
        .profileHeaderGhost,
        .revealController(label: "", Void()),
        .search(placeholder: ""),
        .seeMoreComments,
        .selectableCategoryCard,
        .spacer(height: 0),
        .spinner(height: 0),
        .streamFooter,
        .streamHeader,
        .streamLoading,
        .tallHeader(nil),
        .text(data: nil),
        .toggle,
        .unknown,
        .userAvatars,
        .userListItem
    ]

    var data: Any? {
        switch self {
        case let .artistInviteGuide(data): return data
        case let .embed(data): return data
        case let .header(data): return data
        case let .image(data): return data
        case let .revealController(_, data): return data
        case let .tallHeader(data): return data
        case let .text(data): return data
        default: return nil
        }
    }

    // this is just stupid...
    var equalityIdentifier: String {
        return "\(self)"
    }

    var reuseIdentifier: String {
        switch self {
        case .announcement: return AnnouncementCell.reuseIdentifier
        case .artistInviteAdminControls: return ArtistInviteAdminControlsCell.reuseIdentifier
        case .artistInviteBubble: return ArtistInviteBubbleCell.reuseIdentifier
        case .artistInviteControls: return ArtistInviteControlsCell.reuseIdentifier
        case .artistInviteGuide: return ArtistInviteGuideCell.reuseIdentifier
        case .artistInviteHeader: return ArtistInviteHeaderCell.reuseIdentifier
        case .artistInviteSubmissionsButton: return ArtistInviteSubmissionsButtonCell.reuseIdentifier
        case .badge: return BadgeCell.reuseIdentifier
        case .categoryCard: return CategoryCardCell.reuseIdentifier
        case .categoryList: return CategoryListCell.reuseIdentifier
        case .categoryPromotionalHeader, .pagePromotionalHeader: return CategoryHeaderCell.reuseIdentifier
        case .commentHeader, .streamHeader: return StreamHeaderCell.reuseIdentifier
        case .createComment: return StreamCreateCommentCell.reuseIdentifier
        case let .editorial(kind): return kind.reuseIdentifier
        case .embed: return StreamEmbedCell.reuseEmbedIdentifier
        case .emptyStream: return EmptyStreamCell.reuseEmbedIdentifier
        case .fullWidthSpacer: return "StreamSpacerCell"
        case .header: return TextHeaderCell.reuseIdentifier
        case .image: return StreamImageCell.reuseIdentifier
        case .inviteFriends, .onboardingInviteFriends: return StreamInviteFriendsCell.reuseIdentifier
        case .loadMoreComments: return StreamLoadMoreCommentsCell.reuseIdentifier
        case .noPosts: return NoPostsCell.reuseIdentifier
        case .notification: return NotificationCell.reuseIdentifier
        case .placeholder: return "Placeholder"
        case .profileHeader: return ProfileHeaderCell.reuseIdentifier
        case .profileHeaderGhost: return ProfileHeaderGhostCell.reuseIdentifier
        case .revealController: return RevealControllerCell.reuseIdentifier
        case .search: return SearchStreamCell.reuseIdentifier
        case .seeMoreComments: return StreamSeeMoreCommentsCell.reuseIdentifier
        case .selectableCategoryCard: return CategoryCardCell.selectableReuseIdentifier
        case .spacer: return "StreamSpacerCell"
        case .spinner: return StreamLoadingCell.reuseIdentifier
        case .streamFooter: return StreamFooterCell.reuseIdentifier
        case .streamLoading: return StreamLoadingCell.reuseIdentifier
        case .tallHeader: return TextHeaderCell.reuseIdentifier
        case .text: return StreamTextCell.reuseIdentifier
        case .toggle: return StreamToggleCell.reuseIdentifier
        case .unknown: return "StreamUnknownCell"
        case .userAvatars: return UserAvatarsCell.reuseIdentifier
        case .userListItem: return UserListItemCell.reuseIdentifier
        }
    }

    var isSelectable: Bool {
        switch self {
        case .announcement,
             .artistInviteBubble,
             .badge,
             .categoryCard,
             .createComment,
             .inviteFriends,
             .loadMoreComments,
             .notification,
             .onboardingInviteFriends,
             .revealController,
             .seeMoreComments,
             .selectableCategoryCard,
             .streamHeader,
             .toggle,
             .userListItem:
            return true
        default: return false
        }
    }

    var configure: CellConfigClosure {
        switch self {
        case .announcement: return AnnouncementCellPresenter.configure
        case .artistInviteAdminControls: return ArtistInviteAdminControlsPresenter.configure
        case .artistInviteBubble: return ArtistInviteCellPresenter.configure
        case .artistInviteControls: return ArtistInviteCellPresenter.configure
        case .artistInviteGuide: return ArtistInviteCellPresenter.configureGuide
        case .artistInviteHeader: return ArtistInviteCellPresenter.configure
        case .badge: return BadgeCellPresenter.configure
        case .categoryCard: return CategoryCardCellPresenter.configure
        case .categoryList: return CategoryListCellPresenter.configure
        case .categoryPromotionalHeader: return CategoryHeaderCellPresenter.configure
        case .commentHeader, .streamHeader: return StreamHeaderCellPresenter.configure
        case .createComment: return StreamCreateCommentCellPresenter.configure
        case .editorial: return EditorialCellPresenter.configure
        case .embed: return StreamEmbedCellPresenter.configure
        case .emptyStream: return EmptyStreamCellPresenter.configure
        case .fullWidthSpacer: return { (cell, _, _, _, _) in cell.backgroundColor = .white }
        case .header: return TextHeaderCellPresenter.configure
        case .image: return StreamImageCellPresenter.configure
        case .inviteFriends, .onboardingInviteFriends: return StreamInviteFriendsCellPresenter.configure
        case .noPosts: return NoPostsCellPresenter.configure
        case .notification: return NotificationCellPresenter.configure
        case .pagePromotionalHeader: return PagePromotionalHeaderCellPresenter.configure
        case .profileHeader: return ProfileHeaderCellPresenter.configure
        case .revealController: return RevealControllerCellPresenter.configure
        case .search: return SearchStreamCellPresenter.configure
        case .selectableCategoryCard: return CategoryCardCellPresenter.configure
        case .spacer: return { (cell, _, _, _, _) in cell.backgroundColor = .white }
        case .spinner: return StreamLoadingCellPresenter.configure
        case .streamFooter: return StreamFooterCellPresenter.configure
        case .streamLoading: return StreamLoadingCellPresenter.configure
        case .tallHeader: return TextHeaderCellPresenter.configure
        case .text: return StreamTextCellPresenter.configure
        case .toggle: return StreamToggleCellPresenter.configure
        case .userAvatars: return UserAvatarsCellPresenter.configure
        case .userListItem: return UserListItemCellPresenter.configure
        default: return { _ in }
        }
    }

    var classType: UICollectionViewCell.Type {
        switch self {
        case .announcement: return AnnouncementCell.self
        case .artistInviteAdminControls: return ArtistInviteAdminControlsCell.self
        case .artistInviteBubble: return ArtistInviteBubbleCell.self
        case .artistInviteControls: return ArtistInviteControlsCell.self
        case .artistInviteGuide: return ArtistInviteGuideCell.self
        case .artistInviteHeader: return ArtistInviteHeaderCell.self
        case .artistInviteSubmissionsButton: return ArtistInviteSubmissionsButtonCell.self
        case .badge: return BadgeCell.self
        case .categoryCard: return CategoryCardCell.self
        case .categoryList: return CategoryListCell.self
        case .categoryPromotionalHeader, .pagePromotionalHeader: return CategoryHeaderCell.self
        case .commentHeader, .streamHeader: return StreamHeaderCell.self
        case .createComment: return StreamCreateCommentCell.self
        case let .editorial(kind): return kind.classType
        case .embed: return StreamEmbedCell.self
        case .emptyStream: return EmptyStreamCell.self
        case .header: return TextHeaderCell.self
        case .image: return StreamImageCell.self
        case .inviteFriends, .onboardingInviteFriends: return StreamInviteFriendsCell.self
        case .loadMoreComments: return StreamLoadMoreCommentsCell.self
        case .noPosts: return NoPostsCell.self
        case .notification: return NotificationCell.self
        case .placeholder: return UICollectionViewCell.self
        case .profileHeader: return ProfileHeaderCell.self
        case .profileHeaderGhost: return ProfileHeaderGhostCell.self
        case .revealController: return RevealControllerCell.self
        case .search: return SearchStreamCell.self
        case .seeMoreComments: return StreamSeeMoreCommentsCell.self
        case .selectableCategoryCard: return CategoryCardCell.self
        case .spinner: return StreamLoadingCell.self
        case .streamFooter: return StreamFooterCell.self
        case .streamLoading: return StreamLoadingCell.self
        case .tallHeader: return TextHeaderCell.self
        case .text: return StreamTextCell.self
        case .toggle: return StreamToggleCell.self
        case .unknown, .spacer, .fullWidthSpacer: return UICollectionViewCell.self
        case .userAvatars: return UserAvatarsCell.self
        case .userListItem: return UserListItemCell.self
        }
    }

    var oneColumnHeight: CGFloat {
        switch self {
        case .announcement:
            return 200
        case .artistInviteAdminControls:
            return ArtistInviteAdminControlsCell.Size.height
        case .artistInviteSubmissionsButton:
            return ArtistInviteSubmissionsButtonCell.Size.height
        case .badge:
            return 64
        case .categoryCard, .selectableCategoryCard:
            let width = UIWindow.windowWidth()
            let aspect = CategoryCardCell.Size.aspect
            return ceil(width / aspect)
        case .categoryPromotionalHeader, .pagePromotionalHeader:
            return 150
        case .categoryList:
            return CategoryListCell.Size.height
        case .commentHeader,
             .inviteFriends,
             .onboardingInviteFriends,
             .seeMoreComments:
                return 60
        case .createComment:
            return 75
        case .editorial:
            let width = UIWindow.windowWidth()
            let aspect = EditorialCell.Size.aspect
            let maxHeight: CGFloat = UIWindow.windowHeight() - 256
            let height = min(ceil(width / aspect), maxHeight)
            return height + 1
        case let .emptyStream(height):
            return height
        case let .fullWidthSpacer(height):
            return height
        case .header:
            return 30
        case .loadMoreComments:
            return StreamLoadMoreCommentsCell.Size.height
        case .noPosts:
            return 215
        case .notification:
            return 117
        case .revealController:
            return RevealControllerCell.Size.height
        case .search:
            return 68
        case let .spacer(height):
            return height
        case let .spinner(height):
            return height
        case .streamLoading,
             .userAvatars:
                return 50
        case .streamFooter:
            return 44
        case .streamHeader:
            return 70
        case .tallHeader:
            return 75
        case .toggle:
            return 40
        case .userListItem:
            return 85
        default: return 0
        }
    }

    var multiColumnHeight: CGFloat {
        switch self {
        case .categoryCard, .selectableCategoryCard:
            let windowWidth = UIWindow.windowWidth()
            let columnCount = CGFloat(Window.columnCountFor(width: windowWidth))
            let columnSpacing: CGFloat = 1
            let width = (UIWindow.windowWidth() - columnSpacing * (columnCount - 1)) / columnCount
            let aspect = CategoryCardCell.Size.aspect
            return ceil(width / aspect)
        case .streamHeader,
            .notification:
            return 60
        default:
            return oneColumnHeight
        }
    }

    var isFullWidth: Bool {
        switch self {
        case .announcement,
             .artistInviteAdminControls,
             .artistInviteBubble,
             .artistInviteControls,
             .artistInviteGuide,
             .artistInviteHeader,
             .artistInviteSubmissionsButton,
             .badge,
             .categoryList,
             .categoryPromotionalHeader,
             .createComment,
             .editorial,
             .emptyStream,
             .fullWidthSpacer,
             .header,
             .inviteFriends,
             .loadMoreComments,
             .noPosts,
             .notification,
             .onboardingInviteFriends,
             .pagePromotionalHeader,
             .profileHeader,
             .profileHeaderGhost,
             .revealController,
             .search,
             .seeMoreComments,
             .streamLoading,
             .tallHeader,
             .userAvatars,
             .userListItem:
            return true
        case .categoryCard,
             .commentHeader,
             .embed,
             .image,
             .placeholder,
             .selectableCategoryCard,
             .spacer,
             .spinner,
             .streamFooter,
             .streamHeader,
             .text,
             .toggle,
             .unknown:
            return false
        }
    }

    var isCollapsable: Bool {
        switch self {
        case .image, .text, .embed: return true
        default: return false
        }
    }

    var showsUserRelationship: Bool {
        switch self {
        case .commentHeader, .notification, .streamHeader, .userListItem:
            return true
        default:
            return false
        }
    }

    static func registerAll(_ collectionView: UICollectionView) {
        let noNibTypes: [StreamCellType] = [
            .announcement,
            .artistInviteAdminControls,
            .artistInviteBubble,
            .artistInviteControls,
            .artistInviteGuide(nil),
            .artistInviteHeader,
            .artistInviteSubmissionsButton,
            .badge,
            .categoryCard,
            .categoryList,
            .categoryPromotionalHeader,
            .createComment,
            .editorial(.external),
            .editorial(.internal),
            .editorial(.invite),
            .editorial(.join),
            .editorial(.post),
            .editorial(.postStream),
            .emptyStream(height: 282),
            .fullWidthSpacer(height: 0),
            .header(nil),
            .loadMoreComments,
            .notification,
            .pagePromotionalHeader,
            .placeholder,
            .profileHeader,
            .profileHeaderGhost,
            .revealController(label: "", Void()),
            .search(placeholder: ""),
            .selectableCategoryCard,
            .spacer(height: 0),
            .spinner(height: 0),
            .streamLoading,
            .tallHeader(nil),
            .text(data: nil),
            .unknown,
        ]
        for type in all {
            if noNibTypes.index(of: type) != nil {
                collectionView.register(type.classType, forCellWithReuseIdentifier: type.reuseIdentifier)
            } else {
                let nib = UINib(nibName: type.reuseIdentifier, bundle: Bundle(for: type.classType))
                collectionView.register(nib, forCellWithReuseIdentifier: type.reuseIdentifier)
            }
        }
    }
}
