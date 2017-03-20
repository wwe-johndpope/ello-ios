////
///  VideoCache.swift
//

import PINCache
import PINRemoteImage
import Alamofire
import FutureKit

public enum VideoCacheType {
    case cache
    case network
}

public typealias VideoCacheResult = (URL, VideoCacheType)

public struct VideoCache {

    public func loadVideo(url: URL, withCost cost: Int) -> Future<VideoCacheResult>  {
        let promise = Promise<VideoCacheResult>()
        if
            let destinationData = PINRemoteImageManager.shared().pinCache?.object(forKey: url.absoluteString) as? Data,
            let destinationPath = String(data: destinationData, encoding: .utf8),
            let destinationURL = URL(string: destinationPath)
        {
            promise.completeWithSuccess((destinationURL, VideoCacheType.cache))
        }
        else {
            let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
            Alamofire.download(url, to: destination).response { response in
                guard
                    let destinationURL = response.destinationURL,
                    let serializedURL = destinationURL.absoluteString.data(using: .utf8),
                    response.error == nil
                    else {
                        promise.completeWithFail("Unable to Save")
                        return
                }

                PINRemoteImageManager.shared().pinCache?.setObject(serializedURL, forKey: url.absoluteString, withCost: UInt(cost))
                promise.completeWithSuccess((destinationURL, VideoCacheType.network))
            }
        }

        return promise.future
    }
}
