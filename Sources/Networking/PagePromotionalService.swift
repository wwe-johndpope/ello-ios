////
///  PagePromotionalService.swift
//

import PromiseKit


class PagePromotionalService {

    func loadPromotionals() -> Promise<[PagePromotional]?> {
        return ElloProvider.shared.request(.pagePromotionals)
            .then { data, responseConfig -> [PagePromotional]? in
                if responseConfig.statusCode == 204 {
                    return nil
                }
                else if let pagePromotionals = data as? [PagePromotional] {
                    Preloader().preloadImages(pagePromotionals)
                    return pagePromotionals
                }
                else {
                    throw NSError.uncastableJSONAble()
                }
            }
    }

    func loadCategoryPromotionals() -> Promise<[PagePromotional]?> {
        return loadPromotionals()
            .then { promotionals in
                return promotionals?.filter { $0.isCategory }
            }
    }

    func loadEditorialPromotionals() -> Promise<[PagePromotional]?> {
        return loadPromotionals()
            .then { promotionals in
                return promotionals?.filter { $0.isEditorial }
            }
    }

    func loadArtistInvitePromotionals() -> Promise<[PagePromotional]?> {
        return loadPromotionals()
            .then { promotionals in
                return promotionals?.filter { $0.isArtistInvite }
            }
    }
}
