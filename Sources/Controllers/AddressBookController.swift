////
///  AddressBookController.swift
//

import AddressBook
import Result


public struct AddressBookController {
    static func promptForAddressBookAccess(fromController controller: UIViewController, completion: Result<AddressBook, AddressBookError> -> Void) {
        switch AddressBookController.authenticationStatus() {
        case .Authorized:
            proceedWithImport(completion)
        case .NotDetermined:
            promptForAddressBookAccess(controller, completion: completion)
        case .Denied:
            displayAddressBookAlert(controller, message: InterfaceString.Friends.AccessDenied)
        case .Restricted:
            displayAddressBookAlert(controller, message: InterfaceString.Friends.AccessRestricted)
        }
    }
}

extension AddressBookController {

    private static func promptForAddressBookAccess(controller: UIViewController, completion: Result<AddressBook, AddressBookError> -> Void) {
        let alertController = AlertViewController(message: InterfaceString.Friends.ImportPermissionPrompt, type: .Rounded)

        let importMessage = InterfaceString.Friends.ImportAllow
        let action = AlertAction(title: importMessage, style: .Green) { action in
            Tracker.sharedTracker.importContactsInitiated()
            self.proceedWithImport(completion)
        }
        alertController.addAction(action)

        let cancelMessage = InterfaceString.Friends.ImportNotNow
        let cancelAction = AlertAction(title: cancelMessage, style: .RoundedGrayFill) { _ in
            Tracker.sharedTracker.importContactsDenied()
        }
        alertController.addAction(cancelAction)

        controller.presentViewController(alertController, animated: true, completion: .None)
    }

    private static func proceedWithImport(completion: Result<AddressBook, AddressBookError> -> Void) {
        Tracker.sharedTracker.addressBookAccessed()
        AddressBookController.getAddressBook { result in
            nextTick {
                completion(result)
            }
        }
    }

    private static func displayAddressBookAlert(controller: UIViewController, message: String) {
        let alertController = AlertViewController(
            message: "We were unable to access your address book\n\(message)"
        )

        let action = AlertAction(title: InterfaceString.OK, style: .Dark, handler: .None)
        alertController.addAction(action)

        controller.presentViewController(alertController, animated: true, completion: .None)
    }

    private static func getAddressBook(completion: Result<AddressBook, AddressBookError> -> Void) {
        var error: Unmanaged<CFError>?
        let ab = ABAddressBookCreateWithOptions(nil, &error) as Unmanaged<ABAddressBook>?

        if error != nil {
            completion(.Failure(.Unauthorized))
            return
        }

        if let book: ABAddressBook = ab?.takeRetainedValue() {
            switch ABAddressBookGetAuthorizationStatus() {
            case .NotDetermined:
                ABAddressBookRequestAccessWithCompletion(book) { granted, _ in
                    if granted { completion(.Success(AddressBook(addressBook: book))) }
                    else { completion(.Failure(.Unauthorized)) }
                }
            case .Authorized: completion(.Success(AddressBook(addressBook: book)))
            default: completion(.Failure(.Unauthorized))
            }
        } else {
            completion(.Failure(.Unknown))
        }
    }

    private static func authenticationStatus() -> ABAuthorizationStatus {
        return ABAddressBookGetAuthorizationStatus()
    }
}
