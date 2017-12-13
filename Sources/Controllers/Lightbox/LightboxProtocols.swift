////
///  LightboxProtocols.swift
//

protocol LightboxControllerDelegate: class {
    func lightboxShouldScrollTo(indexPath: IndexPath)
    func lightboxWillDismiss()
}

protocol LightboxScreenDelegate: class {
    func dismiss()
    func didMoveBy(delta: Int)
    func imageURLsForScreen() ->(prev: URL?, current: URL, next: URL?)
}
