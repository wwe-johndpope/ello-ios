////
///  ArtistInviteDetailGenerator.swift
//

final class ArtistInviteDetailGenerator: StreamGenerator {

    var currentUser: User?
    let streamKind: StreamKind
    let artistInvite: ArtistInvite
    weak var destination: StreamDestination?

    fileprivate var localToken: String = ""
    fileprivate var loadingToken = LoadingToken()

    init(artistInvite: ArtistInvite, currentUser: User?, destination: StreamDestination?) {
        self.artistInvite = artistInvite
        self.streamKind = .artistInviteDetail(id: artistInvite.id)
        self.currentUser = currentUser
        self.destination = destination
    }

    func load(reload: Bool = false) {
        localToken = loadingToken.resetInitialPageLoadingToken()
        if !reload {
            setPlaceHolders()
        }
        // loadArtistInvite()
        destination?.setPrimary(jsonable: artistInvite)
        let header = NSAttributedString(label: InterfaceString.ArtistInvites.Submissions, style: .header)
        let submissionsHeader = StreamCellItem(type: .header(header), placeholderType: .artistInviteSubmissions)
        let artistInviteItems = self.parse(jsonables: [artistInvite]) + [submissionsHeader]
        self.destination?.replacePlaceholder(type: .artistInvites, items: artistInviteItems) {
            self.destination?.pagingEnabled = artistInviteItems.count > 0
        }
    }
}

private extension ArtistInviteDetailGenerator {

    func setPlaceHolders() {
        destination?.setPlaceholders(items: [
            StreamCellItem(type: .placeholder, placeholderType: .artistInvites),
            StreamCellItem(type: .placeholder, placeholderType: .artistInviteSubmissions),
        ])
    }

    func loadArtistInvite() {
        StreamService().loadStream(streamKind: streamKind)
            .thenFinally { [weak self] response in
                guard
                    let `self` = self,
                    case let .jsonables(jsonables, responseConfig) = response,
                    let artistInvites = jsonables as? [ArtistInvite]
                else { return }

                self.destination?.setPagingConfig(responseConfig: responseConfig)

                let header = NSAttributedString(label: InterfaceString.ArtistInvites.Submissions, style: .header)
                let submissionsHeader = StreamCellItem(type: .header(header), placeholderType: .artistInviteSubmissions)
                let artistInviteItems = self.parse(jsonables: artistInvites) + [submissionsHeader]
                self.destination?.replacePlaceholder(type: .artistInvites, items: artistInviteItems) {
                    self.destination?.pagingEnabled = artistInviteItems.count > 0
                }
            }
            .catch { [weak self] _ in
                guard let `self` = self else { return }
                self.destination?.primaryJSONAbleNotFound()
            }
    }
}
