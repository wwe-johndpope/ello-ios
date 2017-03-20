////
///  PostService.swift
//

import Foundation
import FutureKit


struct PostService {

    func loadPost(
        _ postParam: String,
        needsComments: Bool) -> Future<Post>
    {
        let commentCount = needsComments ? 10 : 0
        let promise = Promise<Post>()
        ElloProvider.shared.elloRequest(
            ElloAPI.postDetail(postParam: postParam, commentCount: commentCount),
            success: { (data, responseConfig) in
                if let post = data as? Post {
                    Preloader().preloadImages([post])
                    promise.completeWithSuccess(post)
                }
                else {
                    let error = NSError.uncastableJSONAble()
                    promise.completeWithFail(error)
                }
            },
            failure: { (error, _) in
                promise.completeWithFail(error)
            })
        return promise.future
    }

    func sendPostViews(
        posts: [Post] = [],
        comments: [ElloComment] = [],
        streamId: String?,
        streamKind: String,
        userId: String?)
    {
        guard posts.count + comments.count > 0 else { return }

        let postIds = Set(posts.map { $0.id } + comments.map { $0.id })
        ElloProvider.shared.elloRequest(
            ElloAPI.postViews(streamId: streamId, streamKind: streamKind, postIds: postIds, currentUserId: userId),
            success: { _ in })
    }

    func loadPostComments(_ postId: String) -> Future<([ElloComment], ResponseConfig)> {
        let promise = Promise<([ElloComment], ResponseConfig)>()
        ElloProvider.shared.elloRequest(
            ElloAPI.postComments(postId: postId),
            success: { (data, responseConfig) in
                if let comments = data as? [ElloComment] {
                    Preloader().preloadImages(comments)
                    for comment in comments {
                        comment.loadedFromPostId = postId
                    }
                    promise.completeWithSuccess((comments, responseConfig))
                }
                else if data as? String == "" {
                    promise.completeWithSuccess(([], responseConfig))
                }
                else {
                    let error = NSError.uncastableJSONAble()
                    promise.completeWithFail(error)
                }
            },
            failure: { (error, statusCode) in
                promise.completeWithFail(error)
        })
        return promise.future
    }

    func loadPostLovers(_ postId: String) -> Future<[User]> {
        let promise = Promise<[User]>()
        ElloProvider.shared.elloRequest(
            ElloAPI.postLovers(postId: postId),
            success: { (data, responseConfig) in
                if let users = data as? [User] {
                    Preloader().preloadImages(users)
                    promise.completeWithSuccess(users)
                }
                else if data as? String == "" {
                    promise.completeWithSuccess([])
                }
                else {
                    let error = NSError.uncastableJSONAble()
                    promise.completeWithFail(error)
                }
            },
            failure: { (error, statusCode) in
                promise.completeWithFail(error)
            })
        return promise.future
    }

    func loadPostReposters(_ postId: String) -> Future<[User]> {
        let promise = Promise<[User]>()
        ElloProvider.shared.elloRequest(
            ElloAPI.postReposters(postId: postId),
            success: { (data, responseConfig) in
                if let users = data as? [User] {
                    Preloader().preloadImages(users)
                    promise.completeWithSuccess(users)
                }
                else if data as? String == "" {
                    promise.completeWithSuccess([])
                }
                else {
                    let error = NSError.uncastableJSONAble()
                    promise.completeWithFail(error)
                }
            },
            failure: { (error, statusCode) in
                promise.completeWithFail(error)
        })
        return promise.future
    }

    func loadRelatedPosts(_ postId: String)  -> Future<[Post]> {
        let promise = Promise<[Post]>()
//        ElloProvider.shared.elloRequest(
//            ElloAPI.relatedPosts(postId: postId),
//            success: { (data, _) in
//                if let posts = data as? [Post] {
//                    Preloader().preloadImages(posts)
//                    promise.completeWithSuccess(posts)
//                }
//                else {
//                    let error = NSError.uncastableJSONAble()
//                    promise.completeWithFail(error)
//                }
//        },
//            failure: { (error, statusCode) in
//                promise.completeWithFail(error)
//        })
        return promise.future
    }

    func loadComment(_ postId: String, commentId: String) -> Future<ElloComment> {
        let promise = Promise<ElloComment>()
        ElloProvider.shared.elloRequest(
            ElloAPI.commentDetail(postId: postId, commentId: commentId),
            success: { (data, responseConfig) in
                if let comment = data as? ElloComment {
                    comment.loadedFromPostId = postId
                    promise.completeWithSuccess(comment)
                }
                else {
                    let error = NSError.uncastableJSONAble()
                    promise.completeWithFail(error)
                }
            },
            failure: { (error, statusCode) in
                promise.completeWithFail(error)
            })
        return promise.future
    }

    func loadReplyAll(_ postId: String) -> Future<[String]> {
        let promise = Promise<[String]>()
        ElloProvider.shared.elloRequest(
            ElloAPI.postReplyAll(postId: postId),
            success: { (usernames, _) in
                if let usernames = usernames as? [Username] {
                    let strings = usernames
                        .map { $0.username }
                    let uniq = strings.unique()
                    promise.completeWithSuccess(uniq)
                }
                else {
                    let error = NSError.uncastableJSONAble()
                    promise.completeWithFail(error)
                }
            }, failure: { (error, _) in
                promise.completeWithFail(error)
            })
        return promise.future
    }

    func deletePost(_ postId: String) -> Future<()> {
        let promise = Promise<()>()
        ElloProvider.shared.elloRequest(ElloAPI.deletePost(postId: postId),
            success: { (_, _) in
                URLCache.shared.removeAllCachedResponses()
                promise.completeWithSuccess(())
            }, failure: { (error, _) in
                promise.completeWithFail(error)
            }
        )
        return promise.future
    }

    func deleteComment(_ postId: String, commentId: String) -> Future<()> {
        let promise = Promise<()>()
        ElloProvider.shared.elloRequest(ElloAPI.deleteComment(postId: postId, commentId: commentId),
            success: { (_, _) in
                promise.completeWithSuccess(())
            }, failure: { (error, _) in
                promise.completeWithFail(error)
            }
        )
        return promise.future
    }

    func toggleWatchPost(_ post: Post, watching: Bool) -> Future<Post> {
        let api: ElloAPI
        if watching {
            api = ElloAPI.createWatchPost(postId: post.id)
        }
        else {
            api = ElloAPI.deleteWatchPost(postId: post.id)
        }

        let promise = Promise<Post>()
        ElloProvider.shared.elloRequest(api,
            success: { data, _ in
                if watching,
                    let watch = data as? Watch,
                    let post = watch.post
                {
                    promise.completeWithSuccess(post)
                }
                else if !watching {
                    post.watching = false
                    ElloLinkedStore.sharedInstance.setObject(post, forKey: post.id, type: .postsType)
                    promise.completeWithSuccess(post)
                }
                else {
                    let error = NSError.uncastableJSONAble()
                    promise.completeWithFail(error)
                }
            },
            failure: { error, _ in
                promise.completeWithFail(error)
            }
        )
        return promise.future
    }
}
