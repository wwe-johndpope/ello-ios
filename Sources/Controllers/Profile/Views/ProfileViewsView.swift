////
///  ProfileViewsView.swift
//

public class ProfileViewsView: ProfileBaseView {

    let tmpLabel = UITextField()

    public struct Size {}

}

extension ProfileViewsView {

    override func style() {
        backgroundColor = .brownColor()
    }

    override func bindActions() {

    }

    override func setText() {
        tmpLabel.text = "Views View"
        tmpLabel.textAlignment = .Center
    }

    override func arrange() {
        addSubview(tmpLabel)

        tmpLabel.snp_makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.width.equalTo(self)
        }

        layoutIfNeeded()
    }
}

extension ProfileViewsView: ProfileViewProtocol {}
