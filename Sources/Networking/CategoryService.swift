////
///  CategoryService.swift
//

import PINRemoteImage
import FutureKit

public typealias CategoriesCompletion = (categories: [Category]) -> Void

public class CategoryService {

    public func loadCategories() -> Future<[Category]> {
        let promise = Promise<[Category]>()
        ElloProvider.shared.elloRequest(.Categories, success: { (data, responseConfig) in
            if let categories = data as? [Category] {
                Preloader().preloadImages(categories)
                promise.completeWithSuccess(categories)
            }
            else {
                promise.completeWithFail(NSError.uncastableJSONAble())
            }
        }, failure: { (error, _) in
            promise.completeWithFail(error)
        })
        return promise.future
    }

    public func loadCategory(categorySlug: String) -> Future<Category> {
        let promise = Promise<Category>()
        ElloProvider.shared.elloRequest(
            ElloAPI.Category(slug: categorySlug),
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
