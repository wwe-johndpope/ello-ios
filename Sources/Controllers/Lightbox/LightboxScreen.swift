////
///  LightboxScreen.swift
//

import FLAnimatedImage


class LightboxScreen: Screen {
    struct Size {
        static let insets: CGFloat = 10
        static let lilBits: CGFloat = 15
    }
    weak var delegate: LightboxScreenDelegate? {
        didSet { updateImages() }
    }

    private let imagesContainer = UIControl()
    private var gestureDeltaX: CGFloat = 0
    private var panGesture: UIPanGestureRecognizer!

    private var prevImageView = FLAnimatedImageView()
    private var prevURL: URL?

    private var currImageView = FLAnimatedImageView()
    private var currURL: URL?
    private let currLoadingLayer = LoadingGradientLayer()

    private var nextImageView = FLAnimatedImageView()
    private var nextURL: URL?

    override func style() {
        backgroundColor = .clear
        prevImageView.contentMode = .scaleAspectFit
        currImageView.contentMode = .scaleAspectFit
        nextImageView.contentMode = .scaleAspectFit
    }

    override func bindActions() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(gestureMovement(gesture:)))
        imagesContainer.addGestureRecognizer(panGesture)

        imagesContainer.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
    }

    override func arrange() {
        addSubview(imagesContainer)
        imagesContainer.addSubview(prevImageView)
        imagesContainer.addSubview(currImageView)
        imagesContainer.addSubview(nextImageView)

        currLoadingLayer.zPosition = 1
        currLoadingLayer.startAnimating()

        prevImageView.layer.zPosition = 2
        currImageView.layer.zPosition = 2
        nextImageView.layer.zPosition = 2

        imagesContainer.layer.addSublayer(currLoadingLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let loadingSize = StreamPageLoadingCell.Size.height
        currLoadingLayer.frame.size = CGSize(width: loadingSize, height: loadingSize)

        let imageWidth = frame.width - 2 * Size.insets - 2 * Size.lilBits
        let imageHeight = frame.height - 2 * Size.insets
        imagesContainer.frame.size.width = imageWidth * 3 + 2 * Size.insets
        imagesContainer.frame.size.height = frame.height
        imagesContainer.frame.origin.x = -imageWidth + Size.lilBits + gestureDeltaX
        imagesContainer.frame.origin.y = 0

        let views = [prevImageView, currImageView, nextImageView]
        views.eachPair { prevView, view in
            view.frame.origin.y = Size.insets
            view.frame.size = CGSize(
                width: imageWidth,
                height: imageHeight
            )

            if let prevView = prevView {
                view.frame.origin.x = prevView.frame.maxX + Size.insets
            }
            else {
                view.frame.origin.x = 0
            }
        }

        currLoadingLayer.position = currImageView.frame.center
    }

    @objc
    func gestureMovement(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)

        if gesture.state == .ended {
            let velocity = gesture.velocity(in: self)
            let delta: Int
            if translation.x < -20 && velocity.x < 0 && delegate?.imageURLsForScreen().next != nil {
                delta = 1
            }
            else if translation.x > 20 && velocity.x > 0 && delegate?.imageURLsForScreen().prev != nil {
                delta = -1
            }
            else {
                delta = 0
            }

            let imageWidth = frame.width - 2 * Size.insets - 2 * Size.lilBits
            switch delta {
            case -1:
                (nextImageView, currImageView, prevImageView) = (currImageView, prevImageView, nextImageView)
                (currURL, nextURL) = (prevURL, currURL)
                prevURL = nil

                setNeedsLayout()
                layoutIfNeeded()
                imagesContainer.frame.origin.x -= imageWidth
            case 1:
                (prevImageView, currImageView, nextImageView) = (currImageView, nextImageView, prevImageView)
                (prevURL, currURL) = (currURL, nextURL)
                nextURL = nil

                setNeedsLayout()
                layoutIfNeeded()
                imagesContainer.frame.origin.x += imageWidth
            default: break
            }

            elloAnimate {
                self.gestureDeltaX = 0
                self.setNeedsLayout()
                self.layoutIfNeeded()
                self.panGesture.isEnabled = false
            }
            .always {
                self.panGesture.isEnabled = true
            }

            if delta != 0 {
                delegate?.didMoveBy(delta: delta)
                updateImages()
            }
        }
        else {
            gestureDeltaX = translation.x
            setNeedsLayout()
        }
    }

    private func updateImages() {
        let urls = delegate?.imageURLsForScreen()
        let newPrevURL = urls?.prev
        let newCurrURL = urls?.current
        let newNextURL = urls?.next

        let items = [
            (newPrevURL, prevURL, prevImageView),
            (newCurrURL, currURL, currImageView),
            (newNextURL, nextURL, nextImageView),
            ]
        for (newURL, oldURL, imageView) in items {
            if newURL == nil || newURL != oldURL {
                imageView.pin_cancelImageDownload()
                imageView.image = nil
            }

            if let url = newURL, newURL != oldURL {
                imageView.pin_setImage(from: url)
            }
        }

        prevURL = newPrevURL
        currURL = newCurrURL
        nextURL = newNextURL
    }

    @objc
    func dismiss() {
        delegate?.dismiss()
    }

}
