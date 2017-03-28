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

    static let failToLoadMessage = "Fail to Load Video"

    public func loadVideo(url: URL) -> Future<VideoCacheResult>  {
        let promise = Promise<VideoCacheResult>()
        let pinCache = PINRemoteImageManager.shared().pinCache
        let key = url.absoluteString

        pinCache?.containsObject(forKeyAsync: key) { exists in
            guard exists else {
                self.loadVideoFromNetwork(url: url, promise: promise)
                return
            }

            pinCache?.diskCache.fileURL(forKeyAsync: key) { (key, url) in
                guard let url = url else {
                    promise.completeWithFail(VideoCache.failToLoadMessage)
                    return
                }
                promise.completeWithSuccess((url, VideoCacheType.cache))
            }
        }
        return promise.future
    }

    private func loadVideoFromNetwork(url: URL, promise: Promise<VideoCacheResult>) {
        Alamofire.request(url).responseData { response in
            guard
                let data = response.data,
                let pinCache = PINRemoteImageManager.shared().pinCache,
                response.result.isSuccess
            else {
                promise.completeWithFail(VideoCache.failToLoadMessage)
                return
            }

            pinCache.setObjectAsync(data, forKey: url.absoluteString) { (cache, key, _) in
                guard let cache = cache as? PINCache else {
                    promise.completeWithFail(VideoCache.failToLoadMessage)
                    return
                }

                cache.diskCache.fileURL(forKeyAsync: key) { (key, localURL) in
                    guard let localURL = localURL else {
                        promise.completeWithFail(VideoCache.failToLoadMessage)
                        return
                    }
                    promise.completeWithSuccess((localURL, VideoCacheType.network))
                }
            }
        }
    }
}
