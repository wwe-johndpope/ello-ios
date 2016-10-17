////
///  ProfileBioView.swift
//

import WebKit


public class ProfileBioView: ProfileBaseView {
    public struct Size {
        static let margins = UIEdgeInsets(tops: 20, sides: 15)
    }

    public var bio: String = "" {
        didSet {
            bioView.loadHTMLString(StreamTextCellHTML.postHTML(bio), baseURL: NSURL(string: "/"))
        }
    }
    private let bioView = UIWebView()
    private let grayLine = UIView()
}

extension ProfileBioView {

    override func style() {
        grayLine.backgroundColor = .grey6()
    }

    override func bindActions() {
    }

    override func setText() {
    }

    override func arrange() {
        addSubview(bioView)
        addSubview(grayLine)

        bioView.snp_makeConstraints { make in
            make.edges.equalTo(self).inset(Size.margins)
        }

        grayLine.snp_makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalTo(self)
            make.leading.trailing.equalTo(self).inset(ProfileBaseView.Size.grayInset)
        }

        layoutIfNeeded()
    }

    func prepareForReuse() {
        bioView.loadHTMLString("", baseURL: NSURL(string: "/"))
    }
}

extension ProfileBioView: ProfileViewProtocol {}
