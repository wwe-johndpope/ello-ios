////
///  ProfileStatsView.swift
//

public class ProfileStatsView: ProfileBaseView {

    let tmpLabel = UITextField()

    public struct Size {}
}

extension ProfileStatsView {

    override func style() {
        backgroundColor = .yellowColor()
    }

    override func bindActions() {

    }

    override func setText() {
        tmpLabel.text = "Stats View"
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

extension ProfileStatsView: ProfileViewProtocol {}
