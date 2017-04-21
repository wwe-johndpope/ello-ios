////
///  SearchToggleButton.swift
//

import SnapKit


class SearchToggleButton: UIButton {
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

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        style()
        arrange()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func style() {
        titleLabel?.font = .defaultFont()
        setTitleColor(.greyA(), for: .normal)
        setTitleColor(.black, for: .selected)
        updateLineColor()
    }

    private func updateLineColor() {
        line.backgroundColor = isSelected ? .black : .greyF2()
    }

    private func arrange() {
        addSubview(line)
        line.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self)
            make.height.equalTo(Size.lineHeight)
        }
    }
}
