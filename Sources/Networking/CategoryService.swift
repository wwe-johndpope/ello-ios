////
///  CategoryService.swift
//

import PINRemoteImage
import FutureKit

public typealias CategoriesCompletion = (categories: [Category]) -> Void

public class CategoryService {

    public func loadCategories(success: CategoriesCompletion, failure: ElloFailureCompletion = { _ in }) {
        ElloProvider.shared.elloRequest(.Categories, success: { (data, responseConfig) in
            if let categories = data as? [Category] {
                Preloader().preloadImages(categories)
                success(categories: categories)
            }
        }, failure: { (error, statusCode) in
            failure(error: error, statusCode: statusCode)
        })
    }

    public func loadCategory(categoryName: String) -> Future<Category> {
        let promise = Promise<Category>()
        ElloProvider.shared.elloRequest(
            ElloAPI.Category(categoryName: categoryName),
            success: { (data, responseConfig) in
                if let category = data as? Category {
                    Preloader().preloadImages([category])
                    promise.completeWithSuccess(category)
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
