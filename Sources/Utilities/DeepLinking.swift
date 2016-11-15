////
///  DeepLinking.swift
//

public struct DeepLinking {

    public static func showDiscover(navVC navVC: UINavigationController?, currentUser: User?) {
        if navVC?.topViewController is DiscoverAllCategoriesViewController { return }

        let vc = DiscoverAllCategoriesViewController()
        vc.currentUser = currentUser
        navVC?.pushViewController(vc, animated: true)
    }

    public static func showSettings(navVC navVC: UINavigationController?, currentUser: User?) {
        guard let
            settings = UIStoryboard(name: "Settings", bundle: .None).instantiateInitialViewController()
                as? SettingsContainerViewController
        else { return }

        settings.currentUser = currentUser
        navVC?.pushViewController(settings, animated: true)
    }

    public static func showCategory(navVC navVC: UINavigationController?, currentUser: User?, slug: String) {
        guard !DeepLinking.alreadyOnCurrentCategory(navVC: navVC, slug: slug) else { return }

        if let categoryVC = navVC?.topViewController as? CategoryViewController {
            categoryVC.selectCategoryForSlug(slug)
        }
        else {
            let vc = CategoryViewController(slug: slug)
            vc.currentUser = currentUser
            navVC?.pushViewController(vc, animated: true)
        }
    }

    public static func showProfile(navVC navVC: UINavigationController?, currentUser: User?, username: String) {
        let param = "~\(username)"
        guard !DeepLinking.alreadyOnUserProfile(navVC: navVC, userParam: param) else { return }

        let vc = ProfileViewController(userParam: param, username: username)
        vc.currentUser = currentUser
        navVC?.pushViewController(vc, animated: true)
    }

    public static func showPostDetail(navVC navVC: UINavigationController?, currentUser: User?, token: String) {
        let param = "~\(token)"
        guard !DeepLinking.alreadyOnPostDetail(navVC: navVC, postParam: param) else { return }

        let vc = PostDetailViewController(postParam: param)
        vc.currentUser = currentUser
        navVC?.pushViewController(vc, animated: true)
    }

    public static func showSearch(navVC navVC: UINavigationController?, currentUser: User?, terms: String) {
        if let searchVC = navVC?.visibleViewController as? SearchViewController {
            searchVC.searchForPosts(terms)
        }
        else {
            let vc = SearchViewController()
            vc.currentUser = currentUser
            vc.searchForPosts(terms)
            navVC?.pushViewController(vc, animated: true)
        }
    }

    public static func alreadyOnCurrentCategory(navVC navVC: UINavigationController?, slug: String) -> Bool {
        if let categoryVC = navVC?.visibleViewController as? CategoryViewController {
            return slug == categoryVC.slug
        }
        return false
    }

    public static func alreadyOnUserProfile(navVC navVC: UINavigationController?, userParam: String) -> Bool {
        if let profileVC = navVC?.visibleViewController as? ProfileViewController {
            return userParam == profileVC.userParam
        }
        return false
    }

    public static func alreadyOnPostDetail(navVC navVC: UINavigationController?, postParam: String) -> Bool {
        if let postDetailVC = navVC?.visibleViewController as? PostDetailViewController {
            return postParam == postDetailVC.postParam
        }
        return false
    }

}
