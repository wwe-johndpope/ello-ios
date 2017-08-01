////
///  ArtistInvitesProtocols.swift
//

protocol ArtistInvitesScreenDelegate: class {
    func scrollToTop()
}

protocol ArtistInviteConfigurableCell: class {
    var config: ArtistInviteBubbleCell.Config { get set }
}

protocol ArtistInviteResponder: class {
    func tappedArtistInviteSubmissionsButton()
    func tappedArtistInviteSubmitButton()
}
