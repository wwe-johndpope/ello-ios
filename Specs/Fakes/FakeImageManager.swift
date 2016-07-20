////
///  FakeImageManager.swift
//

import PINRemoteImage

public class FakeImageManager: PINRemoteImageManager {

    public var downloads = [NSURL]()

    public func reset() {
        downloads = [NSURL]()
    }

    override public func prefetchImageWithURL(url: NSURL!, options: PINRemoteImageManagerDownloadOptions) {
        downloads.append(url)
    }

}
