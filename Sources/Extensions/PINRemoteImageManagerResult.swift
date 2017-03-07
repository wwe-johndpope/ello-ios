////
///  PINRemoteImageManagerResult.swift
//

import FLAnimatedImage
import PINRemoteImage

public extension PINRemoteImageManagerResult {

    var animatedImage: FLAnimatedImage? {
        return alternativeRepresentation as? FLAnimatedImage
    }

    var isAnimated: Bool {
        return animatedImage != nil
    }

    var imageSize: CGSize? {
        return isAnimated ? animatedImage?.size : image?.size
    }

    var hasImage: Bool {
        return image != nil || animatedImage != nil
    }
}
