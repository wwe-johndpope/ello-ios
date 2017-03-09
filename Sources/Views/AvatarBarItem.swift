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
        self.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("This isn't implemented")
    }

    func setUserAvatar(_ avatar: UIImage) {
        imageURL = nil
        self.image = regularImage(avatar)
        self.selectedImage = selectedImage(image)
    }

    func setUserAvatarURL(_ url: URL?) {
        imageURL = url
        setDefaultImage()

        guard let url = url else { return }

        _ = manager?.downloadImage(with: url, options: [])  { [weak self] result in
            guard
                let `self` = self,
                let image = self.regularImage(result?.image),
                let selectedImage = self.selectedImage(image)
            else { return }
            nextTick {
                self.image = image
                self.selectedImage = selectedImage
            }
        }
    }

    func regularImage(_ image: UIImage?) -> UIImage? {
        return image?.squareImage()?.resizeToSize(CGSize(width: 38, height: 38), padding: 4)?.roundCorners(padding: 4)?.withRenderingMode(.alwaysOriginal)
    }

    func selectedImage(_ image: UIImage?) -> UIImage? {
        return image?.circleOutline(color: .black)?.withRenderingMode(.alwaysOriginal)
    }

    func setDefaultImage() {
        self.image = nil
    }
}
