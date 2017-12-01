////
///  StreamPageLoadingCell.swift
//

class StreamPageLoadingCell: CollectionViewCell {
    static let reuseIdentifier = "StreamPageLoadingCell"
    struct Size {
        static let height: CGFloat = 40
    }

    let gradientLayer = LoadingGradientLayer()

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame.size = CGSize(width: frame.width, height: Size.height)
        gradientLayer.position = layer.bounds.center
    }

    override func arrange() {
        layer.addSublayer(gradientLayer)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        stopAnimating()
    }
}

extension StreamPageLoadingCell: LoadingCell {
    func startAnimating() {
        gradientLayer.startAnimating()
    }

    func stopAnimating() {
        gradientLayer.stopAnimating()
    }
}
