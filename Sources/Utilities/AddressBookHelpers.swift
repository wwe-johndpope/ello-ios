////
///  AddressBookHelpers.swift
//

public struct AddressBookHelpers {
    static public func searchFilter(text: String) -> ((StreamCellItem) -> Bool)? {
        if text.characters.count < 2 { return nil }
        return { item in
            if let user = item.jsonable as? User {
                return user.name.contains(text) || user.username.contains(text)
            }
            else if let person = item.jsonable as? LocalPerson {
                return person.name.contains(text) || person.emails.any { $0.contains(text) }
            }
            return true
        }
    }

    static public func process(contacts: [(LocalPerson, User?)], currentUser: User?) -> [StreamCellItem] {
        var foundItems = [StreamCellItem]()
        var inviteItems = [StreamCellItem]()
        let currentUserEmail = currentUser?.profile?.email
        for contact in contacts {
            let (person, user): (LocalPerson, User?) = contact
            if let user = user {
                foundItems.append(StreamCellItem(jsonable: user, type: .UserListItem))
            }
            else {
                if currentUserEmail == nil || !person.emails.contains(currentUserEmail!) {
                    inviteItems.append(StreamCellItem(jsonable: person, type: .InviteFriends))
                }
            }
        }
        foundItems.sortInPlace { ($0.jsonable as! User).username.lowercaseString < ($1.jsonable as! User).username.lowercaseString }
        inviteItems.sortInPlace { ($0.jsonable as! LocalPerson).name.lowercaseString < ($1.jsonable as! LocalPerson).name.lowercaseString }
        return foundItems + inviteItems
    }
}
