////
///  StreamImageViewer.swift
//

import FLAnimatedImage

class StreamImageViewer {
    var prevWindowSize: CGSize?
    var statusBarWasVisible: Bool?

    weak var presentingController: StreamViewController?

    init(presentingController: StreamViewController) {
        self.presentingController = presentingController
    }
}


// MARK: Public
extension StreamImageViewer {
    func imageTapped(selected index: Int, allItems: [(IndexPath, URL)]) {
        guard let presentingController = presentingController else { return }

        // tell AppDelegate to allow rotation
        AppDelegate.restrictRotation = false
        prevWindowSize = UIWindow.windowSize()

        statusBarWasVisible = presentingController.appViewController?.statusBarIsVisible
        postNotification(StatusBarNotifications.statusBarVisibility, value: false)

        let lightboxViewController = LightboxViewController(selected: index, allItems: allItems)
        lightboxViewController.delegate = self
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

        if let statusBarWasVisible = statusBarWasVisible {
            postNotification(StatusBarNotifications.statusBarVisibility, value: statusBarWasVisible)
        }
    }
}
