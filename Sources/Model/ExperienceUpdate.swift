////
///  ExperienceUpdate.swift
//

public let CommentChangedNotification = TypedNotification<(ElloComment, ContentChange)>(name: "commentChangedNotification")
public let PostChangedNotification = TypedNotification<(Post, ContentChange)>(name: "postChangedNotification")
public let PostCommentsCountChangedNotification = TypedNotification<(Post, Int)>(name: "postCommentsCountChangedNotification")
public let LoveChangedNotification = TypedNotification<(Love, ContentChange)>(name: "loveChangedNotification")
public let RelationshipChangedNotification = TypedNotification<User>(name: "relationshipChangedNotification")
public let BlockedCountChangedNotification = TypedNotification<(String, Int)>(name: "BlockedCountChangedNotification")
public let MutedCountChangedNotification = TypedNotification<(String, Int)>(name: "MutedCountChangedNotification")
public let CurrentUserChangedNotification = TypedNotification<User>(name: "currentUserChangedNotification")
public let SettingChangedNotification = TypedNotification<User>(name: "settingChangedNotification")

public enum ContentChange {
    case Create
    case Read
    case Update
    case Loved
    case Replaced
    case Delete

    public static func updateCommentCount(comment: ElloComment, delta: Int) {
        var affectedPosts: [Post?]
        if comment.postId == comment.loadedFromPostId {
            affectedPosts = [comment.parentPost]
        }
        else {
            affectedPosts = [comment.parentPost, comment.loadedFromPost]
        }
        for post in affectedPosts {
            if let post = post, count = post.commentsCount {
                postNotification(PostCommentsCountChangedNotification, value: (post, delta))
                postNotification(PostChangedNotification, value: (post, .Update))

                // this must happen AFTER the notification, otherwise the
                // storedPost will be in-memory, and the notification will update the comment count
                if let storedPost = ElloLinkedStore.sharedInstance.getObject(post.id, inCollection: MappingType.PostsType.rawValue) as? Post {
                    storedPost.commentsCount = count + delta
                    ElloLinkedStore.sharedInstance.setObject(storedPost, forKey: post.id, inCollection: MappingType.PostsType.rawValue)
                }
            }
        }

    }

}
