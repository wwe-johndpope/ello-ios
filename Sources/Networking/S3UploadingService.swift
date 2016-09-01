////
///  S3UploadingService.swift
//

import Moya
import Foundation
import UIKit

public class S3UploadingService: NSObject {
    typealias S3UploadSuccessCompletion = (url: NSURL?) -> Void

    var uploader: ElloS3?

    func upload(imageRegionData image: ImageRegionData, success: S3UploadSuccessCompletion, failure: ElloFailureCompletion) {
        if let data = image.data, contentType = image.contentType {
            upload(data, contentType: contentType, success: success, failure: failure)
        }
        else {
        }
    }

    func upload(image: UIImage, success: S3UploadSuccessCompletion, failure: ElloFailureCompletion) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if let data = UIImageJPEGRepresentation(image, 0.8) {
                // Head back to the thread the original caller was on before heading into the service calls. I may be overthinking it.
                nextTick {
                    self.upload(data, contentType: "image/jpeg", success: success, failure: failure)
                }
            }
        }
    }

    func upload(data: NSData, contentType: String, success: S3UploadSuccessCompletion, failure: ElloFailureCompletion) {
        let filename: String
        switch contentType {
        case "image/gif":
            filename = "\(NSUUID().UUIDString).gif"
        case "image/png":
            filename = "\(NSUUID().UUIDString).png"
        default:
            filename = "\(NSUUID().UUIDString).jpg"
        }

        ElloProvider.shared.elloRequest(ElloAPI.AmazonCredentials,
            success: { credentialsData, responseConfig in
                if let credentials = credentialsData as? AmazonCredentials {
                    self.uploader = ElloS3(credentials: credentials, filename: filename, data: data, contentType: contentType)
                        .onSuccess({ (data: NSData) in
                            let endpoint: String = credentials.endpoint
                            let prefix: String = credentials.prefix
                            success(url: NSURL(string: "\(endpoint)/\(prefix)/\(filename)"))
                        })
                        .onFailure({ (error: NSError) in
                            _ = failure(error: error, statusCode: nil)
                        })
                        .start()
                }
                else {
                    ElloProvider.unCastableJSONAble(failure)
                }
            },
            failure: failure
        )
    }
}
