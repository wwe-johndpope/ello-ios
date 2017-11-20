////
///  DrawerCell.swift
//

class DrawerCell: TableViewCell {
    static let reuseIdentifier = "DrawerCell"

    struct Size {
        static let height: CGFloat = 72
        static let inset = UIEdgeInsets(sides: 15)
        static let lineHeight: CGFloat = 1
    }

    let label: UILabel = StyledLabel(style: .white)
    let line: UIView = UIView()

    override func styleCell() {
        backgroundColor = .grey6
        line.backgroundColor = .grey5
    }

    override func arrange() {
        contentView.addSubview(label)
        contentView.addSubview(line)

        contentView.snp.makeConstraints { make in
            make.height.equalTo(Size.height)
        }

        label.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.trailing.equalTo(self).inset(Size.inset)
        }

        line.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(self)
            make.height.equalTo(Size.lineHeight)
        }
    }
}
