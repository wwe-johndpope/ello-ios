////
///  ArtistInviteDetailGenerator.swift
//

final class ArtistInviteDetailGenerator: StreamGenerator {

    var currentUser: User?
    let streamKind: StreamKind
    var artistInvite: ArtistInvite?
    var artistInviteDetails: [StreamCellItem] = []
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
            StreamCellItem(type: .placeholder, placeholderType: .artistInviteSubmissionsButton),
            StreamCellItem(type: .placeholder, placeholderType: .artistInviteDetails),
            StreamCellItem(type: .placeholder, placeholderType: .artistInviteAdmin),
            StreamCellItem(type: .placeholder, placeholderType: .artistInviteSubmissionsHeader),
            StreamCellItem(type: .placeholder, placeholderType: .artistInvitePosts),
        ])
    }

    func loadArtistInvite() {
        StreamService().loadStream(streamKind: streamKind)
            .thenFinally { response in
                guard
                    self.loadingToken.isValidInitialPageLoadingToken(self.localToken),
                    case let .jsonables(jsonables, responseConfig) = response,
                    let artistInvites = jsonables as? [ArtistInvite],
                    let artistInvite = artistInvites.first
                else { throw NSError.uncastableJSONAble() }

                self.destination?.setPagingConfig(responseConfig: responseConfig)
                self.setArtistInvite(artistInvite)
            }
            .catch { _ in
                self.destination?.primaryJSONAbleNotFound()
            }
    }

    func setArtistInvite(_ artistInvite: ArtistInvite) {
        self.artistInvite = artistInvite
        destination?.setPrimary(jsonable: artistInvite)

        let artistInviteItems = parse(jsonables: [artistInvite])
        let headers = artistInviteItems.filter { $0.placeholderType == .artistInvites }
        self.artistInviteDetails = artistInviteItems.filter { $0.placeholderType == .artistInviteDetails }
        destination?.replacePlaceholder(type: .artistInvites, items: headers)

        let postsSpinner = StreamCellItem(type: .streamLoading, placeholderType: .artistInvitePosts)
        destination?.replacePlaceholder(type: .artistInviteDetails, items: [postsSpinner])

        loadSubmissions(artistInvite)
    }

    func loadSubmissions(_ artistInvite: ArtistInvite) {
        guard let endpoint = artistInvite.approvedSubmissionsStream?.endpoint else {
            showSubmissionsError()
            return
        }

        StreamService().loadStream(endpoint: endpoint)
            .thenFinally { response in
                guard
                    self.loadingToken.isValidInitialPageLoadingToken(self.localToken)
                else { return }

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
                    let header = NSAttributedString(label: InterfaceString.ArtistInvites.Submissions, style: .header)
                    let submissionsHeader = StreamCellItem(type: .header(header))
                    self.destination?.replacePlaceholder(type: .artistInviteSubmissionsHeader, items: [submissionsHeader])

                    let button = StreamCellItem(type: .artistInviteSubmissionsButton, placeholderType: .artistInviteSubmissionsButton)
                    self.destination?.replacePlaceholder(type: .artistInviteSubmissionsButton, items: [button])

                    let items = self.parse(jsonables: posts)
                    self.destination?.replacePlaceholder(type: .artistInvitePosts, items: items)
                }
            }
            .catch { _ in
                self.showSubmissionsError()
            }
            .always { _ in
                self.loadAdminTools(artistInvite)
                self.destination?.replacePlaceholder(type: .artistInviteDetails, items: self.artistInviteDetails)
            }
    }

    func showEmptySubmissions() {
        destination?.replacePlaceholder(type: .artistInviteSubmissionsButton, items: [])
        destination?.replacePlaceholder(type: .artistInviteSubmissionsHeader, items: [])
        destination?.replacePlaceholder(type: .artistInvitePosts, items: [])
    }

    func showSubmissionsError() {
        let error = NSAttributedString(label: InterfaceString.ArtistInvites.SubmissionsError, style: .error)
        let item = StreamCellItem(type: .header(error))
        destination?.replacePlaceholder(type: .artistInvitePosts, items: [item])
    }

    func loadAdminTools(_ artistInvite: ArtistInvite) {
        guard
            artistInvite.hasAdminLinks,
            let approvedSubmissionsStream = artistInvite.approvedSubmissionsStream,
            let selectedSubmissionsStream = artistInvite.selectedSubmissionsStream,
            let unapprovedSubmissionsStream = artistInvite.unapprovedSubmissionsStream
        else { return }

        let header = NSAttributedString(label: "Admin Controls", style: .header)
        let submissionsHeader = StreamCellItem(type: .header(header))
        let approvedButton = StreamCellItem(type: .revealController(label: InterfaceString.ArtistInvites.AdminApprovedStream, approvedSubmissionsStream))
        let selectedButton = StreamCellItem(type: .revealController(label: InterfaceString.ArtistInvites.AdminSelectedStream, selectedSubmissionsStream))
        let unapprovedButton = StreamCellItem(type: .revealController(label: InterfaceString.ArtistInvites.AdminUnapprovedStream, unapprovedSubmissionsStream))
        let spacer = StreamCellItem(type: .spacer(height: 30))
        self.destination?.replacePlaceholder(type: .artistInviteAdmin, items: [
            submissionsHeader,
            unapprovedButton,
            approvedButton,
            selectedButton,
            spacer,
            ])
    }
}
