////
///  ProfileNameView.swift
//

public class ProfileNameView: ProfileBaseView {

    let tmpLabel = UITextField()

    public struct Size {
    }
}

extension ProfileNameView {

    override func style() {
        backgroundColor = .magentaColor()
    }

    override func bindActions() {

    }

    override func setText() {
        tmpLabel.text = "Name View"
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

extension ProfileNameView: ProfileViewProtocol {}
