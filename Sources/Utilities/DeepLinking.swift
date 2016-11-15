////
///  DeepLinking.swift
//

public struct DeepLinking {

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
