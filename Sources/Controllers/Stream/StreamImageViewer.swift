////
///  StreamImageViewer.swift
//

import FLAnimatedImage

class StreamImageViewer {
    var prevWindowSize: CGSize?

    weak var presentingController: StreamViewController?

    init(presentingController: StreamViewController) {
        self.presentingController = presentingController
    }
}


// MARK: Public
extension StreamImageViewer {
    func imageTapped(selected index: Int, allItems: [LightboxViewController.Item], currentUser: User?) {
        guard let presentingController = presentingController else { return }

        // tell AppDelegate to allow rotation
        AppDelegate.restrictRotation = false
        prevWindowSize = UIWindow.windowSize()

        let lightboxViewController = LightboxViewController(selected: index, allItems: allItems)
        lightboxViewController.currentUser = currentUser
        lightboxViewController.delegate = self
        lightboxViewController.postbarController = presentingController.postbarController
        presentingController.present(lightboxViewController, animated: true, completion: .none)
    }
}

extension StreamImageViewer: LightboxControllerDelegate {
    func lightboxShouldScrollTo(indexPath: IndexPath) {
        presentingController?.scrollTo(indexPath: indexPath)
    }

    func lightboxWillDismiss() {
        AppDelegate.restrictRotation = true

        if let prevSize = prevWindowSize, prevSize != UIWindow.windowSize() {
            postNotification(Application.Notifications.ViewSizeWillChange, value: UIWindow.windowSize())
        }
    }
}
