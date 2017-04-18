////
///  ProfileTotalCountPresenter.swift
//

struct ProfileTotalCountPresenter {

    static func configure(
        _ view: ProfileTotalCountView,
        user: User,
        currentUser: User?)
    {
        view.count = user.formattedTotalCount
        view.badgeVisible = (user.categories?.count ?? 0) > 0
    }
}
