////
///  CategoryService.swift
//

import PINRemoteImage
import PromiseKit


private var cachedCategories: [Category]?

class CategoryService {

    func loadCategories() -> Promise<[Category]> {
        if let categories = cachedCategories {
            return Promise<[Category]>.resolve(categories)
        }

        return ElloProvider.shared.request(.categories)
            .then { data, _ -> [Category] in
                guard let categories = data as? [Category] else {
                    throw NSError.uncastableJSONAble()
                }
                cachedCategories = categories
                Preloader().preloadImages(categories)
                return categories
            }
    }

    func loadCreatorCategories() -> Promise<[Category]> {
        return loadCategories()
            .then { categories -> [Category] in
                return categories.filter { $0.isCreatorType }
            }
    }

    func loadCategory(_ categorySlug: String) -> Promise<Category> {
        if let category = cachedCategories?.find({ $0.slug == categorySlug }) {
            return Promise<Category>.resolve(category)
        }

        return ElloProvider.shared.request(.category(slug: categorySlug))
            .then { data, _ -> Category in
                guard let category = data as? Category else {
                    throw NSError.uncastableJSONAble()
                }
                Preloader().preloadImages([category])
                return category
            }
    }

}
