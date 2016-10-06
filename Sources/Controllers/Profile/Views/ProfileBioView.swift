////
///  ProfileBioView.swift
//

public class ProfileBioView: ProfileBaseView {

    let tmpLabel = UITextField()

    public struct Size {}
}

extension ProfileBioView {

    override func style() {
        backgroundColor = .greenColor()
    }

    override func bindActions() {

    }

    override func setText() {
        tmpLabel.text = "Profile Bio View"
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

extension ProfileBioView: ProfileViewProtocol {}
