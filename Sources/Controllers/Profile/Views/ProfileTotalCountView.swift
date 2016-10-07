////
///  ProfileTotalCountView.swift
//

public class ProfileTotalCountView: ProfileBaseView {

    let tmpLabel = UITextField()

    public struct Size {}

}

extension ProfileTotalCountView {

    override func style() {
        backgroundColor = .brownColor()
    }

    override func bindActions() {

    }

    override func setText() {
        tmpLabel.text = "Total Count View"
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

extension ProfileTotalCountView: ProfileViewProtocol {}
