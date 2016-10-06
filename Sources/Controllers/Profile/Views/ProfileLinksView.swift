////
///  ProfileLinksView.swift
//

public class ProfileLinksView: ProfileBaseView {

    let tmpLabel = UITextField()

    public struct Size {}
}

extension ProfileLinksView {

    override func style() {
        backgroundColor = .redColor()
    }

    override func bindActions() {

    }

    override func setText() {
        tmpLabel.text = "Profile Links View"
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

extension ProfileLinksView: ProfileViewProtocol {}
