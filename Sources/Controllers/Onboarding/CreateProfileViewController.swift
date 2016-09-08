////
///  CreateProfileViewController.swift
//

public class CreateProfileViewController: UIViewController, HasAppController {
    var mockScreen: CreateProfileScreenProtocol?
    var screen: CreateProfileScreenProtocol { return mockScreen ?? (self.view as! CreateProfileScreenProtocol) }
    var parentAppController: AppViewController?
    var currentUser: User?

    public var onboardingViewController: OnboardingViewController?
    public var onboardingData: OnboardingData!
    var didSetName = false
    var didSetBio = false
    var didSetLinks = false
    var didUploadCoverImage = false
    var didUploadAvatarImage = false
    var didSetAnything = false

    override public func loadView() {
        let screen = CreateProfileScreen()
        screen.delegate = self
        self.view = screen
    }
}

extension CreateProfileViewController: CreateProfileDelegate {
    func presentController(controller: UIViewController) {
        presentViewController(controller, animated: true, completion: nil)
    }

    func dismissController() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func assignName(name: String?) {
        onboardingData.name = name
        didSetAnything = didSetAnything || (name?.isEmpty == false)
        didSetName = true
        onboardingViewController?.canGoNext = didSetAnything
    }

    func assignBio(bio: String?) {
        onboardingData.bio = bio
        didSetAnything = didSetAnything || (bio?.isEmpty == false)
        didSetBio = true
        onboardingViewController?.canGoNext = didSetAnything
    }

    func assignLinks(links: String?) {
        onboardingData.links = links
        didSetAnything = didSetAnything || (links?.isEmpty == false)
        didSetLinks = true
        onboardingViewController?.canGoNext = didSetAnything
    }

    func assignCoverImage(image: ImageRegionData) {
        didUploadCoverImage = true
        onboardingData.coverImage = image
        didSetAnything = true
        onboardingViewController?.canGoNext = didSetAnything
    }
    func assignAvatar(image: ImageRegionData) {
        didUploadAvatarImage = true
        onboardingData.avatarImage = image
        didSetAnything = true
        onboardingViewController?.canGoNext = didSetAnything
    }
}

extension CreateProfileViewController: OnboardingStepController {
    public func onboardingStepBegin() {
        if onboardingData.name?.isEmpty == false ||
            onboardingData.bio?.isEmpty == false ||
            onboardingData.links?.isEmpty == false ||
            onboardingData.coverImage != nil ||
            onboardingData.avatarImage != nil
        {
            didSetAnything = true
            onboardingViewController?.canGoNext = true
        }
        screen.name = onboardingData.name
        screen.bio = onboardingData.bio
        screen.links = onboardingData.links
        screen.coverImage = onboardingData.coverImage
        screen.avatarImage = onboardingData.avatarImage
    }

    public func onboardingWillProceed(abort: Bool, proceedClosure: (success: Bool?) -> Void) {
        var properties: [String: AnyObject] = [:]
        if let name = onboardingData.name where didSetName {
            Tracker.sharedTracker.enteredOnboardName()
            properties["name"] = name
        }

        if let bio = onboardingData.bio where didSetBio {
            Tracker.sharedTracker.enteredOnboardBio()
            properties["unsanitized_short_bio"] = bio
        }

        if let links = onboardingData.links where didSetLinks {
            Tracker.sharedTracker.enteredOnboardLinks()
            properties["external_links"] = links
        }

        let failure: (NSError) -> Void = { error in
            let alertController = AlertViewController(error: error.elloErrorMessage ?? InterfaceString.GenericError)
            self.parentAppController?.presentViewController(alertController, animated: true, completion: nil)
        }

        let avatarImage: ImageRegionData? = didUploadAvatarImage ? onboardingData.avatarImage : nil
        let coverImage: ImageRegionData? = didUploadCoverImage ? onboardingData.coverImage : nil

        guard avatarImage != nil || coverImage != nil || !properties.isEmpty else {
            goToNextStep(abort, proceedClosure: proceedClosure)
            return
        }

        ProfileService().updateUserImages(
            avatarImage: avatarImage, coverImage: coverImage,
            properties: properties,
            success: { _ in
                self.goToNextStep(abort, proceedClosure: proceedClosure) },
            failure: { error, _ in
                proceedClosure(success: nil)
                failure(error)
            })
    }

    func goToNextStep(abort: Bool, proceedClosure: (success: Bool) -> Void) {
        guard let
            presenter = onboardingViewController?.parentAppController
        where !abort else {
            proceedClosure(success: false)
            return
        }

        Tracker.sharedTracker.inviteFriendsTapped()
        AddressBookController.promptForAddressBookAccess(fromController: self) { result in
            switch result {
            case let .Success(addressBook):
                Tracker.sharedTracker.contactAccessPreferenceChanged(true)

                let vc = InviteFriendsViewController(addressBook: addressBook)
                vc.currentUser = self.currentUser
                vc.onboardingViewController = self.onboardingViewController
                self.onboardingViewController?.inviteFriendsController = vc

                proceedClosure(success: true)
            case let .Failure(addressBookError):
                guard addressBookError != .Cancelled else {
                    proceedClosure(success: false)
                    return
                }

                Tracker.sharedTracker.contactAccessPreferenceChanged(false)
                let message = addressBookError.rawValue
                let alertController = AlertViewController(error: "We were unable to access your address book\n\(message)")
                presenter.presentViewController(alertController, animated: true, completion: .None)
            }
        }
    }
}
