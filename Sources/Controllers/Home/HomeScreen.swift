////
///  HomeScreen.swift
//


class HomeScreen: Screen, HomeScreenProtocol {
    weak var delegate: HomeScreenDelegate?
    let controllerContainer = UIView()

    override func arrange() {
        super.arrange()

        controllerContainer.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}
