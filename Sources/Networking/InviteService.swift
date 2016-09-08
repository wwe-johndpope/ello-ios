////
///  InviteService.swift
//

import Moya
import SwiftyJSON

public typealias InviteFriendsSuccessCompletion = () -> Void
public typealias FindFriendsSuccessCompletion = ([(LocalPerson, User?)]) -> Void

public struct InviteService {

    public init(){}

    public func invite(contact: String, success: InviteFriendsSuccessCompletion, failure: ElloFailureCompletion) {
        ElloProvider.shared.elloRequest(ElloAPI.InviteFriends(contact: contact),
            success: { _ in success() },
            failure: failure)
    }

    public func find(addressBook: AddressBookProtocol, currentUser: User?, success: FindFriendsSuccessCompletion, failure: ElloFailureCompletion) {
        var contacts = [String: [String]]()
        for person in addressBook.localPeople {
            contacts[person.identifier] = person.emails
        }

        ElloProvider.shared.elloRequest(ElloAPI.FindFriends(contacts: contacts),
            success: { (data, responseConfig) in
                if let data = data as? [User] {
                    let users = InviteService.filterUsers(data, currentUser: currentUser)
                    let userIdentifiers = users.map { $0.identifiableBy ?? "" }
                    let mixed: [(LocalPerson, User?)] = addressBook.localPeople.map {
                        if let index = userIdentifiers.indexOf($0.identifier) {
                            return ($0, users[index])
                        }
                        return ($0, .None)
                    }

                    success(mixed)
                }
                else {
                    ElloProvider.unCastableJSONAble(failure)
                }
            }, failure: failure)
    }

    static func filterUsers(users: [User], currentUser: User?) -> [User] {
        return users.filter { $0.identifiableBy != .None && $0.id != currentUser?.id }
    }

}
