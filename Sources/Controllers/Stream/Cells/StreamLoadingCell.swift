////
///  StreamLoadingCell.swift
//

class StreamLoadingCell: CollectionViewCell {
    static let reuseIdentifier = "StreamLoadingCell"

    let elloLogo = ElloLogoView(style: .loading)

    func start() {
        elloLogo.animateLogo()
    }

    func stop() {
        elloLogo.stopAnimatingLogo()
    }

    override func arrange() {
        addSubview(elloLogo)

        elloLogo.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }

    override func style() {
        backgroundColor = .white
    }
}
