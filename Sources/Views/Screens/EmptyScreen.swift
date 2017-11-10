////
///  EmptyScreen.swift
//

import SnapKit


class EmptyScreen: Screen {
    var blackBarIsVisible: Bool {
        get { return !blackBar.isHidden }
        set {
            if newValue {
                blackBarHeightConstraint.deactivate()
            }
            else {
                blackBarHeightConstraint.activate()
            }
            blackBar.isHidden = !newValue
        }
    }
    let blackBar = BlackBar()
    private var blackBarHeightConstraint: Constraint!

    override func arrange() {
        addSubview(blackBar)

        blackBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self)
            blackBarHeightConstraint = make.height.equalTo(0).priority(Priority.required).constraint
        }
        blackBarHeightConstraint.deactivate()
    }
}
