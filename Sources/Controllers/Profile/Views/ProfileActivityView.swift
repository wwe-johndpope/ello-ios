////
///  ProfileActivityView.swift
//

public class ProfileActivityView: ProfileBaseView {

    let tmpLabel = UITextField()

    public struct Size {}
}

extension ProfileActivityView {

    override func style() {
        backgroundColor = .yellowColor()
    }

    override func bindActions() {

    }

    override func setText() {
        tmpLabel.text = "Profile Activity View"
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

extension ProfileActivityView: ProfileViewProtocol {}
