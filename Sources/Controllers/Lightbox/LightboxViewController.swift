////
///  LightboxViewController.swift
//

class LightboxViewController: UIViewController {
    private let allItems: [(IndexPath, URL)]
    private var selectedIndex: Int
    weak var delegate: LightboxControllerDelegate?

    init(selected index: Int, allItems: [(IndexPath, URL)]) {
        self.allItems = allItems
        self.selectedIndex = index
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    required init(coder: NSCoder) {
        fatalError("This isn't implemented")
    }

    override func loadView() {
        let view = LightboxScreen()
        view.delegate = self
        self.view = view
    }
}

extension LightboxViewController: LightboxScreenDelegate {
    @objc
    func dismiss() {
        delegate?.lightboxWillDismiss()
        dismiss(animated: true, completion: .none)
    }

    func didMoveBy(delta: Int) {
        guard selectedIndex + delta >= 0 && selectedIndex + delta < allItems.count else { return }
        selectedIndex += delta
        delegate?.lightboxShouldScrollTo(indexPath: allItems[selectedIndex].0)
    }

    func imageURLsForScreen() ->(prev: URL?, current: URL, next: URL?) {
        let prev = selectedIndex > 0 ? allItems[selectedIndex - 1].1 : nil
        let current = allItems[selectedIndex].1
        let next = selectedIndex + 1 < allItems.count ? allItems[selectedIndex + 1].1 : nil
        return (prev: prev, current: current, next: next)
    }
}

// MARK: UIViewControllerTransitioningDelegate
extension LightboxViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        guard presented == self else { return nil }

        return AlertPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
