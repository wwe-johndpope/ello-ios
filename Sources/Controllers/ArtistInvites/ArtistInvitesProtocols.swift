////
///  ArtistInvitesProtocols.swift
//

protocol ArtistInvitesScreenDelegate: class {
    func scrollToTop()
}

protocol ArtistInvitesScreenProtocol: StreamableScreenProtocol {
}

protocol ArtistInviteDetailScreenDelegate: class {
}

protocol ArtistInviteDetailScreenProtocol: StreamableScreenProtocol {
}

protocol ArtistInviteConfigurableCell: class {
    var config: ArtistInviteBubbleCell.Config { get set }
}

protocol ArtistInviteResponder: class {
    func tappedArtistInviteSubmissionsButton()
    func tappedArtistInviteSubmitButton()
}
