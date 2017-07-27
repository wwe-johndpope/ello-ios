////
///  ArtistInviteDetailGenerator.swift
//

final class ArtistInviteDetailGenerator: StreamGenerator {

    var currentUser: User?
    let streamKind: StreamKind
    var artistInvite: ArtistInvite?
    weak var destination: StreamDestination?

    fileprivate var localToken: String = ""
    fileprivate var loadingToken = LoadingToken()

    init(artistInviteId: String, currentUser: User?, destination: StreamDestination?) {
        self.streamKind = .artistInviteDetail(id: artistInviteId)
        self.currentUser = currentUser
        self.destination = destination
    }

    func load(reload: Bool = false) {
        localToken = loadingToken.resetInitialPageLoadingToken()
        if !reload {
            setPlaceHolders()
        }

        if !reload, let artistInvite = artistInvite {
            setArtistInvite(artistInvite)
        }
        else {
            loadArtistInvite()
        }
    }
}

private extension ArtistInviteDetailGenerator {

    func setPlaceHolders() {
        destination?.setPlaceholders(items: [
            StreamCellItem(type: .placeholder, placeholderType: .artistInvites),
            StreamCellItem(type: .placeholder, placeholderType: .artistInviteSubmissions),
            StreamCellItem(type: .placeholder, placeholderType: .artistInvitePosts),
        ])
    }

    func loadArtistInvite() {
        StreamService().loadStream(streamKind: streamKind)
            .thenFinally { [weak self] response in
                guard
                    let `self` = self,
                    case let .jsonables(jsonables, responseConfig) = response,
                    let artistInvites = jsonables as? [ArtistInvite],
                    let artistInvite = artistInvites.first
                else { throw NSError.uncastableJSONAble() }

                self.destination?.setPagingConfig(responseConfig: responseConfig)
                self.setArtistInvite(artistInvite)
            }
            .catch { [weak self] _ in
                guard let `self` = self else { return }
                self.destination?.primaryJSONAbleNotFound()
            }
    }

    func setArtistInvite(_ artistInvite: ArtistInvite) {
        self.artistInvite = artistInvite
        destination?.setPrimary(jsonable: artistInvite)

        let artistInviteItems = parse(jsonables: [artistInvite])
        destination?.replacePlaceholder(type: .artistInvites, items: artistInviteItems) {}

        let header = NSAttributedString(label: InterfaceString.ArtistInvites.Submissions, style: .header)
        let submissionsHeader = StreamCellItem(type: .header(header))
        destination?.replacePlaceholder(type: .artistInviteSubmissions, items: [submissionsHeader]) {}

        let spinner = StreamCellItem(type: .streamLoading, placeholderType: .artistInvitePosts)
        destination?.replacePlaceholder(type: .artistInvitePosts, items: [spinner]) {}

        loadSubmissions(artistInvite)
    }

    func loadSubmissions(_ artistInvite: ArtistInvite) {
        guard let endpoint = artistInvite.approvedSubmissionsStream?.endpoint else {
            showSubmissionsError()
            return
        }

        StreamService().loadStream(endpoint: endpoint)
            .thenFinally { [weak self] response in
                guard let `self` = self else { return }

                if case .empty = response {
                    self.showEmptySubmissions()
                    return
                }

                guard
                    case let .jsonables(jsonables, _) = response,
                    let submissions = jsonables as? [ArtistInviteSubmission]
                else { throw NSError.uncastableJSONAble() }

                let posts = submissions.flatMap { $0.post }
                if posts.count == 0 {
                    self.showEmptySubmissions()
                }
                else {
                    let items = self.parse(jsonables: posts)
                    self.destination?.replacePlaceholder(type: .artistInvitePosts, items: items) {}
                }
            }
            .catch { [weak self] _ in
                self?.showSubmissionsError()
            }
    }

    func showEmptySubmissions() {
        self.destination?.replacePlaceholder(type: .artistInviteSubmissions, items: []) {}
        self.destination?.replacePlaceholder(type: .artistInvitePosts, items: []) {}
    }

    func showSubmissionsError() {
        let error = NSAttributedString(label: InterfaceString.ArtistInvites.SubmissionsError, style: .error)
        let item = StreamCellItem(type: .header(error))
        self.destination?.replacePlaceholder(type: .artistInvitePosts, items: [item]) {}
    }
}
