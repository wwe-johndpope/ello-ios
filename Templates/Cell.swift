////
///  YourCell.swift
//

import SnapKit


class YourCell: CollectionViewCell {
    static let reuseIdentifier = "YourCell"

    struct Size {
    }

    struct Config {}

    var config = Config() {
        didSet {
            updateConfig()
        }
    }

    override func style() {
    }

    override func arrange() {
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        config = Config()
    }

    func updateConfig() {
    }
}
