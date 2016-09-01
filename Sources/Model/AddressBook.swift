////
///  AddressBook.swift
//

import AddressBook
import Result

public protocol ContactList {
    var localPeople: [LocalPerson] { get }
}

public struct AddressBook: ContactList {
    private let addressBook: ABAddressBook
    public let localPeople: [LocalPerson]

    public init(addressBook: ABAddressBook) {
        self.addressBook = addressBook
        localPeople = getAllPeopleWithEmailAddresses(addressBook)
    }
}

private func getAllPeopleWithEmailAddresses(addressBook: ABAddressBook) -> [LocalPerson] {
    return records(addressBook)?.map { person in
        let emails = getEmails(person)
        let name = ABRecordCopyCompositeName(person)?.takeUnretainedValue() as String? ?? emails.first ?? "NO NAME"
        let id = ABRecordGetRecordID(person)
        return LocalPerson(name: name, emails: emails, id: id)
        }.filter { $0.emails.count > 0 } ?? []
}

private func getEmails(record: ABRecordRef) -> [String] {
    let multiEmails: ABMultiValue? = ABRecordCopyValue(record, kABPersonEmailProperty)?.takeUnretainedValue()

    var emails = [String]()
    for i in 0..<(ABMultiValueGetCount(multiEmails)) {
        if let value = ABMultiValueCopyValueAtIndex(multiEmails, i).takeRetainedValue() as? String {
            emails.append(value)
        }
    }

    return emails
}

private func records(addressBook: ABAddressBook) -> [ABRecordRef]? {
    return ABAddressBookCopyArrayOfAllPeople(addressBook)?.takeUnretainedValue() as [ABRecordRef]?
}
