////
///  View.swift
//

class View: UIView {
    required override init(frame: CGRect) {
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

    convenience init() {
        self.init(frame: .zero)
    }
}

extension View {
    func style() {}
    func bindActions() {}
    func setText() {}
    func arrange() {}
}
