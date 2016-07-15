////
///  StreamEmbedCell.swift
//

public class StreamEmbedCell: StreamImageCell {
    static let reuseEmbedIdentifier = "StreamEmbedCell"

    @IBOutlet weak var playIcon: UIImageView!
    public var embedUrl: NSURL?

    @IBAction override func imageTapped() {
        if let url = embedUrl {
            postNotification(ExternalWebNotification, value: url.URLString)
        }
    }

    public func setPlayImageIcon(icon: InterfaceImage) {
        playIcon.image = icon.normalImage
    }
}
