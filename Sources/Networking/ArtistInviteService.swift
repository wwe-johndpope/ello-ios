////
///  ArtistInviteService.swift
//

import PromiseKit


class ArtistInviteService {

    func performAction(action: ArtistInviteSubmission.Action) -> Promise<ArtistInviteSubmission> {
        return ElloProvider.shared.request(action.endpoint)
            .then { data, _ -> ArtistInviteSubmission in
                if let submission = data as? ArtistInviteSubmission {
                    return submission
                }
                else {
                    throw NSError.uncastableJSONAble()
                }
            }
    }

}
