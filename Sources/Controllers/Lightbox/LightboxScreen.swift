////
///  LightboxScreen.swift
//

import FLAnimatedImage


class LightboxScreen: Screen {
    struct Size {
        static let insets = calculateInsets()
        static let lilBits: CGFloat = 15

        private static func calculateInsets() -> UIEdgeInsets {
            if Globals.isIphoneX {
                return UIEdgeInsets(top: Globals.statusBarHeight, left: 10, bottom: Globals.bestBottomMargin, right: 10)
            }
            return UIEdgeInsets(all: 10)
        }
    }
    weak var delegate: LightboxScreenDelegate? {
        didSet { updateImages() }
    }

    enum Delta: Int {
        case prev = -1
        case next = 1
    }

    private let imagesContainer = UIControl()
    private var gestureDeltaX: CGFloat = 0
    private var scrollPanGesture: UIPanGestureRecognizer!
    private var imagePanGesture: UIPanGestureRecognizer!
    private var scaleGesture: UIPinchGestureRecognizer!
    private var doubleTapGesture: UITapGestureRecognizer!
    private var singleTapGesture: UITapGestureRecognizer!

    private var imageScale: CGFloat = 1
    private var imageOffset: CGPoint = .zero
    private var tempOffset: CGPoint = .zero

    private var prevImageView = FLAnimatedImageView()
    private var prevURL: URL?

    private var currImageView = FLAnimatedImageView()
    private var currImageFrame: CGRect = .zero
    private var currURL: URL?
    private let currLoadingLayer = LoadingGradientLayer()

    private var nextImageView = FLAnimatedImageView()
    private var nextURL: URL?

    override func style() {
        prevImageView.alpha = 0.5
        currImageView.alpha = 1
        nextImageView.alpha = 0.5

        backgroundColor = .clear
        prevImageView.contentMode = .scaleAspectFit
        currImageView.contentMode = .scaleAspectFit
        nextImageView.contentMode = .scaleAspectFit
    }

    override func bindActions() {
        scrollPanGesture = UIPanGestureRecognizer(target: self, action: #selector(scrollPanGestureMovement(gesture:)))
        imagesContainer.addGestureRecognizer(scrollPanGesture)

        imagePanGesture = UIPanGestureRecognizer(target: self, action: #selector(imagePanGestureMovement(gesture:)))
        imagePanGesture.isEnabled = false
        imagesContainer.addGestureRecognizer(imagePanGesture)

        scaleGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureMovement(gesture:)))
        imagesContainer.addGestureRecognizer(scaleGesture)

        doubleTapGesture = UITapGestureRecognizer()
        doubleTapGesture.numberOfTouchesRequired = 1
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.addTarget(self, action: #selector(imageDoubleTapped))
        doubleTapGesture.isEnabled = false
        imagesContainer.addGestureRecognizer(doubleTapGesture)

        singleTapGesture = UITapGestureRecognizer()
        singleTapGesture.numberOfTouchesRequired = 1
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.addTarget(self, action: #selector(dismiss))
        imagesContainer.addGestureRecognizer(singleTapGesture)
    }

    override func arrange() {
        addSubview(imagesContainer)

        imagesContainer.addSubview(prevImageView)
        imagesContainer.addSubview(nextImageView)
        imagesContainer.addSubview(currImageView)

        let loadingSize = StreamPageLoadingCell.Size.height
        currLoadingLayer.frame.size = CGSize(width: loadingSize, height: loadingSize)
        currLoadingLayer.cornerRadius = loadingSize / 2
        currLoadingLayer.masksToBounds = true
        currLoadingLayer.zPosition = 1

        prevImageView.layer.zPosition = 2
        currImageView.layer.zPosition = 3
        nextImageView.layer.zPosition = 2

        imagesContainer.layer.addSublayer(currLoadingLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let imageWidth = frame.width - Size.insets.left - Size.insets.right - 2 * Size.lilBits
        let imageHeight = frame.height - Size.insets.top - Size.insets.bottom
        imagesContainer.frame.size.width = imageWidth * 3 + Size.insets.left + Size.insets.right
        imagesContainer.frame.size.height = frame.height
        imagesContainer.frame.origin.x = -imageWidth + Size.lilBits + gestureDeltaX
        imagesContainer.frame.origin.y = 0

        let views = [prevImageView, currImageView, nextImageView]
        views.eachPair { prevView, view in
            view.frame.origin.y = Size.insets.top
            view.frame.size = CGSize(
                width: imageWidth,
                height: imageHeight
            )

            if let prevView = prevView {
                view.frame.origin.x = prevView.frame.maxX + Size.insets.left
            }
            else {
                view.frame.origin.x = 0
            }
        }

        currImageFrame = currImageView.frame
        prevImageView.layer.zPosition = 2
        currImageView.layer.zPosition = 3
        nextImageView.layer.zPosition = 2

        currLoadingLayer.position = currImageView.frame.center
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()

        if window != nil {
            currLoadingLayer.startAnimating()
        }
    }

    @objc
    func pinchGestureMovement(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .began {
            gesture.scale = imageScale
        }
        else if gesture.state == .changed {
            imageScale = gesture.scale
            updateImageTransform(animated: false)
        }
        else if gesture.state == .ended {
            normalizeImageTransform()
        }
    }

    @objc
    func imagePanGestureMovement(gesture: UIPanGestureRecognizer) {
        var translation = gesture.translation(in: self)
        translation.x /= imageScale
        translation.y /= imageScale

        if gesture.state == .began {
            tempOffset = imageOffset
        }
        else if gesture.state == .changed {
            imageOffset = CGPoint(
                x: tempOffset.x + translation.x,
                y: tempOffset.y + translation.y)
            updateImageTransform(animated: false)
        }
        else if gesture.state == .ended {
            normalizeImageTransform()
        }
    }

    @objc
    func scrollPanGestureMovement(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)

        if gesture.state == .began {
            imageScale = 1
            imageOffset = .zero
            updateImageTransform(animated: true)
        }
        else if gesture.state == .ended {
            let velocity = gesture.velocity(in: self)
            let delta: Delta?
            if translation.x < -20 && velocity.x < 0 && delegate?.imageURLsForScreen().next != nil {
                delta = .next
            }
            else if translation.x > 20 && velocity.x > 0 && delegate?.imageURLsForScreen().prev != nil {
                delta = .prev
            }
            else {
                delta = nil
            }

            let imageWidth = frame.width - Size.insets.left - Size.insets.right - 2 * Size.lilBits
            if let delta = delta {
                switch delta {
                case .prev:
                    (prevImageView, currImageView, nextImageView) = (nextImageView, prevImageView, currImageView)
                    (prevURL, currURL, nextURL) = (nil, prevURL, currURL)

                    setNeedsLayout()
                    layoutIfNeeded()
                    imagesContainer.frame.origin.x -= imageWidth
                case .next:
                    (prevImageView, currImageView, nextImageView) = (currImageView, nextImageView, prevImageView)
                    (prevURL, currURL, nextURL) = (currURL, nextURL, nil)

                    setNeedsLayout()
                    layoutIfNeeded()
                    imagesContainer.frame.origin.x += imageWidth
                }
            }

            elloAnimate {
                self.gestureDeltaX = 0
                self.setNeedsLayout()
                self.layoutIfNeeded()
                self.scrollPanGesture.isEnabled = false

                self.prevImageView.alpha = 0.5
                self.currImageView.alpha = 1
                self.nextImageView.alpha = 0.5
            }
            .always {
                self.scrollPanGesture.isEnabled = true
            }

            if let delta = delta {
                delegate?.didMoveBy(delta: delta.rawValue)
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

        if let imageSuperview = currImageView.superview {
            currImageView.removeFromSuperview()
            imageSuperview.addSubview(currImageView)
        }

        let items = [
            (newPrevURL, prevURL, prevImageView, false),
            (newCurrURL, currURL, currImageView, true),
            (newNextURL, nextURL, nextImageView, false),
            ]
        for (newURL, oldURL, imageView, isCurrent) in items {
            if newURL == nil || newURL != oldURL {
                imageView.pin_cancelImageDownload()
                imageView.image = nil
            }

            if let url = newURL, newURL != oldURL {
                if isCurrent { currLoadingLayer.opacity = 1 }
                imageView.pin_setImage(from: url) { result in
                    if isCurrent { self.currLoadingLayer.opacity = 0 }
                }
            }
        }

        prevURL = newPrevURL
        currURL = newCurrURL
        nextURL = newNextURL
    }

    private func normalizeImageTransform() {
        var adjusted = false
        if imageScale < 1 {
            imageScale = 1
            imageOffset = .zero
            adjusted = true
        }
        else {
            guard let imageSize = currImageView.image?.size else { return }

            let actualImageScale = min(currImageView.frame.width / imageSize.width, currImageView.frame.height / imageSize.height)
            let actualImageSize = CGSize(width: imageSize.width * actualImageScale, height: imageSize.height * actualImageScale)
            let adjustedActualFrame = CGRect(
                x: currImageView.frame.minX + (currImageView.frame.width - actualImageSize.width) / 2,
                y: currImageView.frame.minY + (currImageView.frame.height - actualImageSize.height) / 2,
                width: actualImageSize.width,
                height: actualImageSize.height
                )

            if adjustedActualFrame.width < currImageFrame.width {
                if adjustedActualFrame.minX < currImageFrame.minX {
                    let delta = currImageFrame.minX - adjustedActualFrame.minX
                    imageOffset.x += delta / imageScale
                    adjusted = true
                }
                else if adjustedActualFrame.maxX > currImageFrame.maxX {
                    let delta = adjustedActualFrame.maxX - currImageFrame.maxX
                    imageOffset.x -= delta / imageScale
                    adjusted = true
                }
            }
            else {
                if adjustedActualFrame.minX > currImageFrame.minX {
                    let delta = adjustedActualFrame.minX - currImageFrame.minX
                    imageOffset.x -= delta / imageScale
                    adjusted = true
                }
                else if adjustedActualFrame.maxX < currImageFrame.maxX {
                    let delta = currImageFrame.maxX - adjustedActualFrame.maxX
                    imageOffset.x += delta / imageScale
                    adjusted = true
                }
            }

            if adjustedActualFrame.height < currImageFrame.height {
                if adjustedActualFrame.minY < currImageFrame.minY {
                    let delta = currImageFrame.minY - adjustedActualFrame.minY
                    imageOffset.y += delta / imageScale
                    adjusted = true
                }
                else if adjustedActualFrame.maxY > currImageFrame.maxY {
                    let delta = adjustedActualFrame.maxY - currImageFrame.maxY
                    imageOffset.y -= delta / imageScale
                    adjusted = true
                }
            }
            else {
                if adjustedActualFrame.minY > currImageFrame.minY {
                    let delta = adjustedActualFrame.minY - currImageFrame.minY
                    imageOffset.y -= delta / imageScale
                    adjusted = true
                }
                else if adjustedActualFrame.maxY < currImageFrame.maxY {
                    let delta = currImageFrame.maxY - adjustedActualFrame.maxY
                    imageOffset.y += delta / imageScale
                    adjusted = true
                }
            }
        }

        if adjusted {
            updateImageTransform(animated: true)
        }
    }

    private func updateImageTransform(animated: Bool) {
        if imageScale > 1 {
            imagePanGesture.isEnabled = true
            scrollPanGesture.isEnabled = false
            doubleTapGesture.isEnabled = true
            singleTapGesture.isEnabled = false
        }
        else {
            imagePanGesture.isEnabled = false
            scrollPanGesture.isEnabled = true
            doubleTapGesture.isEnabled = false
            singleTapGesture.isEnabled = true
        }

        var transform = CATransform3DIdentity
        transform = CATransform3DScale(transform, imageScale, imageScale, 1.01)
        transform = CATransform3DTranslate(transform, imageOffset.x, imageOffset.y, 0)

        elloAnimate(animated: animated) {
            self.currImageView.layer.transform = transform
        }
    }

    @objc
    func imageDoubleTapped() {
        imageScale = 1
        imageOffset = .zero
        updateImageTransform(animated: true)
    }

    @objc
    func dismiss() {
        delegate?.dismiss()
    }

}
