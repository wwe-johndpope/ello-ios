////
///  ProfileCategoriesPresentationController.swift
//

import UIKit

public class ProfileCategoriesPresentationController: UIPresentationController {

    let background: UIView = {
        let background = UIView(frame: .zero)
        background.backgroundColor = UIColor.modalBackground()
        return background
    }()

    public init(presentedViewController: UIViewController, presentingViewController: UIViewController?, backgroundColor: UIColor) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        self.background.backgroundColor = backgroundColor
    }
}

// MARK: Presentation
public extension ProfileCategoriesPresentationController {
    override public func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
            background.alpha = 0
            background.frame = containerView.bounds
            containerView.addSubview(background)

        let transitionCoordinator = presentingViewController.transitionCoordinator()
        transitionCoordinator?.animateAlongsideTransition({ _ in
                self.background.alpha = 1
            }, completion: .None)
        if let presentedView = presentedView() {
            containerView.addSubview(presentedView)
        }
    }

    override public func dismissalTransitionWillBegin() {
        let transitionCoordinator = presentingViewController.transitionCoordinator()
        transitionCoordinator?.animateAlongsideTransition({ _ in
            self.background.alpha = 0
            }, completion: .None)
    }

    override public func dismissalTransitionDidEnd(completed: Bool) {
        if completed {
            background.removeFromSuperview()
        }
    }
}
