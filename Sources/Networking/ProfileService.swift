////
///  ProfileService.swift
//

import Moya
import SwiftyJSON

public typealias AccountDeletionSuccessCompletion = () -> Void
public typealias ProfileSuccessCompletion = (user: User) -> Void
public typealias ProfileUploadSuccessCompletion = (url: NSURL, user: User) -> Void
public typealias ProfileUploadBothSuccessCompletion = (avatarURL: NSURL, coverImageURL: NSURL, user: User) -> Void

public struct ProfileService {

    public init(){}

    public func loadCurrentUser(success success: ProfileSuccessCompletion, failure: ElloFailureCompletion) {
        let endpoint: ElloAPI = .CurrentUserProfile
        ElloProvider.shared.elloRequest(endpoint,
            success: { (data, _) in
                if let user = data as? User {
                    success(user: user)
                }
                else {
                    ElloProvider.unCastableJSONAble(failure)
                }
            },
            failure: failure )
    }

    public func updateUserProfile(content: [String: AnyObject], success: ProfileSuccessCompletion, failure: ElloFailureCompletion) {
        ElloProvider.shared.elloRequest(ElloAPI.ProfileUpdate(body: content),
            success: { data, responseConfig in
                if let user = data as? User {
                    success(user: user)
                } else {
                    ElloProvider.unCastableJSONAble(failure)
                }
            },
            failure: failure
        )
    }

    public func updateUserCoverImage(
        image: ImageRegionData,
        properties: [String: AnyObject] = [:],
        success: ProfileUploadSuccessCompletion, failure: ElloFailureCompletion) {
        updateUserImage(image, key: "remote_cover_image_url", properties: properties, success: { (url, user) in
            TemporaryCache.save(.CoverImage, image: image.image)
            success(url: url, user: user)
        }, failure: failure)
    }

    public func updateUserAvatarImage(
        image: ImageRegionData,
        properties: [String: AnyObject] = [:],
        success: ProfileUploadSuccessCompletion, failure: ElloFailureCompletion) {
        updateUserImage(image, key: "remote_avatar_url", properties: properties, success: { (url, user) in
            TemporaryCache.save(.Avatar, image: image.image)
            success(url: url, user: user)
        }, failure: failure)
    }

    public func updateUserImages(
        avatarImage avatarImage: ImageRegionData,
        coverImage: ImageRegionData,
        properties: [String: AnyObject] = [:],
        success: ProfileUploadBothSuccessCompletion,
        failure: ElloFailureCompletion
    ) {
        var avatarURL: NSURL?
        var coverImageURL: NSURL?
        var error: NSError?
        var statusCode: Int?
        let bothImages = after(2) {
            if let error = error {
                failure(error: error, statusCode: statusCode)
            }
            else if let avatarURL = avatarURL, coverImageURL = coverImageURL {
                TemporaryCache.save(.CoverImage, image: avatarImage.image)
                TemporaryCache.save(.Avatar, image: coverImage.image)
                let mergedProperties: [String: AnyObject] = properties + [
                    "remote_cover_image_url": coverImageURL.absoluteString,
                    "remote_avatar_url": avatarURL.absoluteString,
                ]
                self.updateUserProfile(mergedProperties, success: { user in
                    success(avatarURL: avatarURL, coverImageURL: coverImageURL, user: user)
                }, failure: failure)
            }
        }

        S3UploadingService().upload(imageRegionData: avatarImage, success: { url in
            avatarURL = url
            bothImages()
        }, failure: { uploadError, uploadStatusCode in
            error = error ?? uploadError
            statusCode = statusCode ?? uploadStatusCode
            bothImages()
        })

        S3UploadingService().upload(imageRegionData: coverImage, success: { url in
            coverImageURL = url
            bothImages()
        }, failure: { uploadError, uploadStatusCode in
            error = error ?? uploadError
            statusCode = statusCode ?? uploadStatusCode
            bothImages()
        })
    }

    public func updateUserDeviceToken(token: NSData) {
        ElloProvider.shared.elloRequest(ElloAPI.PushSubscriptions(token: token),
            success: { _, _ in })
    }

    public func removeUserDeviceToken(token: NSData) {
        ElloProvider.shared.elloRequest(ElloAPI.DeleteSubscriptions(token: token),
            success: { _, _ in })
    }

    private func updateUserImage(image: ImageRegionData, key: String, properties: [String: AnyObject], success: ProfileUploadSuccessCompletion, failure: ElloFailureCompletion) {
        S3UploadingService().upload(imageRegionData: image, success: { url in
            if let url = url {
                let mergedProperties: [String: AnyObject] = properties + [
                    key: url.absoluteString,
                ]
                self.updateUserProfile(mergedProperties, success: { user in
                    success(url: url, user: user)
                }, failure: failure)
            }
        }, failure: failure)
    }

    public func deleteAccount(success success: AccountDeletionSuccessCompletion, failure: ElloFailureCompletion) {
        ElloProvider.shared.elloRequest(ElloAPI.ProfileDelete,
            success: { _, _ in success() },
            failure: failure)
    }
}
