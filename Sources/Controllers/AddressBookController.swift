////
///  AddressBookController.swift
//

import AddressBook
import Result


typealias Completion = Result<AddressBook, AddressBookError> -> Void

public struct AddressBookController {
    static func promptForAddressBookAccess(fromController controller: UIViewController, completion: Completion) {
        switch AddressBookController.authenticationStatus() {
        case .Authorized:
            proceedWithImport(completion)
        case .NotDetermined:
            promptForAddressBookAccess(controller, completion: completion)
        case .Denied:
            displayAddressBookAlert(controller, message: InterfaceString.Friends.AccessDenied, completion: completion)
        case .Restricted:
            displayAddressBookAlert(controller, message: InterfaceString.Friends.AccessRestricted, completion: completion)
        }
    }
}

extension AddressBookController {

    private static func promptForAddressBookAccess(controller: UIViewController, completion: Completion) {
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

    private static func proceedWithImport(completion: Completion) {
        Tracker.sharedTracker.addressBookAccessed()
        AddressBookController.getAddressBook { result in
            nextTick {
                completion(result)
            }
        }
    }

    private static func displayAddressBookAlert(controller: UIViewController, message: String, completion: Completion) {
        let alertController = AlertViewController(
            message: "We were unable to access your address book\n\(message)"
        )

        let action = AlertAction(title: InterfaceString.OK, style: .Dark) { _ in
            completion(.Failure(.Cancelled))
        }
        alertController.addAction(action)

        controller.presentViewController(alertController, animated: true, completion: .None)
    }

    private static func getAddressBook(completion: Completion) {
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
                    if granted {
                        nextTick { completion(.Success(AddressBook(addressBook: book))) }
                    }
                    else {
                        nextTick { completion(.Failure(.Unauthorized)) }
                    }
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
