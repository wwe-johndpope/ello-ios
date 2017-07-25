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

protocol ArtistInviteCell: class {
    var config: ArtistInviteBubbleCell.Config { get set }
}
