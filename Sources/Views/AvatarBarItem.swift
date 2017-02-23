////
///  AvatarBarItem.swift
//

import PINRemoteImage

class AvatarBarItem: UITabBarItem {
    // for specs; ensure the correct URL is assigned
    var imageURL: URL?

    var avatarImage: UIImage?
    var manager = PINRemoteImageManager.shared()

    override init() {
        super.init()
        self.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("This isn't implemented")
    }

    func setUserAvatar(_ image: UIImage) {
        imageURL = nil
        self.image = image
    }

    func setUserAvatarURL(_ url: URL?) {
        imageURL = url
        setDefaultImage()

        guard let url = url else { return }

        _ = manager?.downloadImage(with: url, options: [])  { [weak self] result in
            guard
                let `self` = self,
                let image = result?.image.squareImage()?.resizeToSize(CGSize(width: 30, height: 30))?.roundCorners(),
                let selectedImage = image.circleOutline(color: .black)
            else { return }
            nextTick {
                self.image = image.withRenderingMode(.alwaysOriginal)
                self.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
            }
        }
    }

    func setDefaultImage() {
        self.image = nil
    }
}
