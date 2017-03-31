////
///  ProfileLinksPresenter.swift
//

struct ProfileLinksPresenter {

    static func configure(
        _ view: ProfileLinksView,
        user: User,
        currentUser: User?)
    {
        guard let links = user.externalLinksList else { return }

        view.externalLinks = links
    }
}
