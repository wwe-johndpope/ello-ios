////
///  SearchToggleButton.swift
//

import SnapKit


class SearchToggleButton: Button {
    struct Size {
        static let lineHeight: CGFloat = 1
    }

    private let line = UIView()
    override var isSelected: Bool {
        didSet {
            animate {
                self.updateLineColor()
            }
        }
    }

    override func style() {
        titleLabel?.font = .defaultFont()
        setTitleColor(.greyA, for: .normal)
        setTitleColor(.black, for: .selected)
        updateLineColor()
    }

    override func arrange() {
        addSubview(line)
        line.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self)
            make.height.equalTo(Size.lineHeight)
        }
    }

    private func updateLineColor() {
        line.backgroundColor = isSelected ? .black : .greyF2
    }
}
