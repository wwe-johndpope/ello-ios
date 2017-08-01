////
///  EmptyScreen.swift
//

class EmptyScreen: Screen {
    var blackBar = BlackBar()

    override func arrange() {
        addSubview(blackBar)

        blackBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self)
        }
    }
}
