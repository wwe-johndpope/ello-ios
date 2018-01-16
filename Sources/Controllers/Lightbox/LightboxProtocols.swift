////
///  LightboxProtocols.swift
//

protocol LightboxControllerDelegate: class {
    func lightboxShouldScrollTo(indexPath: IndexPath)
    func lightboxWillDismiss()
}

protocol LightboxScreenDelegate: class {
    func viewAction()
    func loveAction(animationLocation: CGPoint)
    func loveAction()
    func repostAction()
    func shareAction(control: UIView)

    func dismissAction()
    func isDifferentPost(delta: Int) -> Bool
    func didMoveBy(delta: Int)
    func imageURLsForScreen() ->(prev: URL?, current: URL, next: URL?)
    func configureToolbar(_: PostToolbar)
}
