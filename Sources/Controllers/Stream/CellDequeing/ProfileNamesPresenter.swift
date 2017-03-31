////
///  ProfileNamesPresenter.swift
//

struct ProfileNamesPresenter {

    static func configure(
        _ view: ProfileNamesView,
        user: User,
        currentUser: User?)
    {
        view.name = user.name
        view.username = user.atName
    }
}
