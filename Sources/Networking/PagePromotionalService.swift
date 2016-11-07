////
///  PagePromotionalService.swift
//

import PINRemoteImage
import FutureKit


public class PagePromotionalService {

    public func loadPagePromotionals() -> Future<[PagePromotional]> {
        let promise = Promise<[PagePromotional]>()
        ElloProvider.shared.elloRequest(.PagePromotionals,
            success: { (data, responseConfig) in
                if let pagePromotionals = data as? [PagePromotional] {
                    Preloader().preloadImages(pagePromotionals)
                    promise.completeWithSuccess(pagePromotionals)
                }
                else {
                    promise.completeWithFail(NSError.uncastableJSONAble())
                }
            }, failure: { (error, statusCode) in
                promise.completeWithFail(error)
            })
        return promise.future
    }
}
