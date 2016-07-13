////
///  AddressBookError.swift
//

public enum AddressBookError: String, ErrorType {
    case Unauthorized = "Please make sure that you have granted Ello access to your contacts in the Privacy Settings"
    case Unknown = "Something went wrong! Please try again."
}
