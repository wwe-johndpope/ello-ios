////
///  ArtistInviteAdminGenerator.swift
//

final class ArtistInviteAdminGenerator: StreamGenerator {

    var currentUser: User?
    var streamKind: StreamKind = .artistInvites
    let artistInvite: ArtistInvite
    var stream: ArtistInvite.Stream
    weak var destination: StreamDestination?

    fileprivate var localToken: String = ""
    fileprivate var loadingToken = LoadingToken()

    init(artistInvite: ArtistInvite, stream: ArtistInvite.Stream, currentUser: User?, destination: StreamDestination?) {
        self.artistInvite = artistInvite
        self.stream = stream
        self.currentUser = currentUser
        self.destination = destination
    }

    func load(reload: Bool = false) {
        localToken = loadingToken.resetInitialPageLoadingToken()
        if !reload {
            setPlaceHolders()
        }

        loadArtistInvites()
    }
}

private extension ArtistInviteAdminGenerator {

    func setPlaceHolders() {
        destination?.setPlaceholders(items: [
            StreamCellItem(type: .placeholder, placeholderType: .artistInvitePosts),
        ])
    }

    func loadArtistInvites() {
        StreamService().loadStream(endpoint: stream.endpoint)
            .thenFinally { [weak self] response in
                guard
                    let `self` = self,
                    self.loadingToken.isValidInitialPageLoadingToken(self.localToken)
                else { return }

                guard
                    case let .jsonables(jsonables, responseConfig) = response,
                    let submissions = jsonables as? [ArtistInviteSubmission]
                else {
                    self.destination?.primaryJSONAbleNotFound()
                    return
                }

                self.destination?.setPagingConfig(responseConfig: responseConfig)

                let artistInviteItems = self.parse(jsonables: submissions)
                self.destination?.replacePlaceholder(type: .artistInvitePosts, items: artistInviteItems) {
                    self.destination?.isPagingEnabled = artistInviteItems.count > 0
                }
            }
            .catch { [weak self] _ in
                guard let `self` = self else { return }
                self.destination?.primaryJSONAbleNotFound()
            }
    }
}
