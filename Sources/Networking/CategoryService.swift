////
///  CategoryService.swift
//

import PINRemoteImage

public typealias CategoriesCompletion = (categories: [Category]) -> Void

public class CategoryService {

    public func loadCategories(success: CategoriesCompletion, failure: ElloFailureCompletion = { _ in }) {
        ElloProvider.shared.elloRequest(.Categories, success: { (data, responseConfig) in
            if let categories = data as? [Category] {
                let manager = PINRemoteImageManager.sharedImageManager()
                for tileURL in (categories.flatMap { $0.tileURL }) {
                    manager.prefetchImageWithURL(tileURL, options: PINRemoteImageManagerDownloadOptions.DownloadOptionsNone)
                }
                success(categories: categories)
            }
        }, failure: { (error, statusCode) in
            failure(error: error, statusCode: statusCode)
        })
    }

}
