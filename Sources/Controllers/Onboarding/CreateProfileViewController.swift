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
    public func onboardingWillProceed(abort: Bool, proceedClosure: () -> Void) {
        if onboardingData.name?.isEmpty == false {
            Tracker.sharedTracker.enteredOnboardName()
        }
        if onboardingData.name?.isEmpty == false {
            Tracker.sharedTracker.enteredOnboardBio()
        }
        if onboardingData.name?.isEmpty == false {
            Tracker.sharedTracker.enteredOnboardLinks()
        }

        var properties: [String: AnyObject] = [:]
        if let name = onboardingData.name where didSetName {
            properties["name"] = name
        }
        if let bio = onboardingData.bio where didSetBio {
            properties["external_links"] = bio
        }
        if let links = onboardingData.links where didSetLinks {
            properties["unsanitized_short_bio"] = links
        }

        let failure: (NSError) -> Void = { _ in
            let alertController = AlertViewController(error: InterfaceString.GenericError)
            self.parentAppController?.presentViewController(alertController, animated: true, completion: nil)
        }

        if let
            avatarImage = onboardingData.avatarImage,
            coverImage = onboardingData.coverImage
        where didUploadAvatarImage && didUploadCoverImage
        {
            ProfileService().updateUserImages(
                avatarImage: avatarImage, coverImage: coverImage,
                properties: properties,
                success: { _ in
                    self.goToNextStep(abort, proceedClosure: proceedClosure) },
                failure: { error, _ in
                    failure(error)
                })
        }
        else if let avatarImage = onboardingData.avatarImage where didUploadAvatarImage {
            ProfileService().updateUserAvatarImage(
                avatarImage,
                properties: properties,
                success: { _ in
                    self.goToNextStep(abort, proceedClosure: proceedClosure) },
                failure: { error, _ in
                    failure(error)
                })
        }
        else if let coverImage = onboardingData.coverImage where didUploadCoverImage {
            ProfileService().updateUserCoverImage(
                coverImage,
                properties: properties,
                success: { _ in
                    self.goToNextStep(abort, proceedClosure: proceedClosure) },
                failure: { error, _ in
                    failure(error)
                })
        }
        else if !properties.isEmpty {
            ProfileService().updateUserProfile(
                properties,
                success: { _ in
                    self.goToNextStep(abort, proceedClosure: proceedClosure) },
                failure: { error, _ in
                    failure(error)
                })
        }
        else {
            goToNextStep(abort, proceedClosure: proceedClosure)
        }
    }

    func goToNextStep(abort: Bool, proceedClosure: () -> Void) {
        guard let
            presenter = onboardingViewController?.parentAppController
        where !abort else {
            proceedClosure()
            return
        }

        Tracker.sharedTracker.inviteFriendsTapped()
        AddressBookController.promptForAddressBookAccess(fromController: self) { result in
            switch result {
            case let .Success(addressBook):
                Tracker.sharedTracker.contactAccessPreferenceChanged(true)
                let vc = AddFriendsViewController(addressBook: addressBook)
                vc.currentUser = self.currentUser
                presenter.presentViewController(vc, animated: true, completion: nil)
            case let .Failure(addressBookError):
                Tracker.sharedTracker.contactAccessPreferenceChanged(false)
                let message = addressBookError.rawValue
                let alertController = AlertViewController(error: "We were unable to access your address book\n\(message)")
                presenter.presentViewController(alertController, animated: true, completion: .None)
            }
        }
    }

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
}
