////
///  CollectionViewCell.swift
//

class CollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        bindActions()
        setText()
        arrange()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        style()
        bindActions()
        setText()
        arrange()
    }

    func style() {}
    func bindActions() {}
    func setText() {}
    func arrange() {}

}
