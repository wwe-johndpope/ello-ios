////
///  ProfileLinksView.swift
//

import SnapKit


public class ProfileLinksView: ProfileBaseView {
    public struct Size {
        static let margins = UIEdgeInsets(all: 15)
        static let iconSize = CGSize(width: 22, height: 22)
        static let iconMargins: CGFloat = 10
        static let verticalLinkMargin: CGFloat = 3
        static let horizLinkButtonMargin: CGFloat = 5
    }

    var buttonsWidthConstraint: Constraint!

    private var linksBox = UIView()
    private var buttonsBox = UIView()
}

extension ProfileLinksView {

    override func style() {
        linksBox.backgroundColor = .redColor()
        buttonsBox.backgroundColor = .magentaColor()
    }

    override func bindActions() {
    }

    override func setText() {
    }

    override func arrange() {
        addSubview(linksBox)
        addSubview(buttonsBox)

        linksBox.snp_makeConstraints { make in
            make.leading.top.bottom.equalTo(self).inset(Size.margins)
            make.trailing.equalTo(buttonsBox.snp_leading).offset(-Size.horizLinkButtonMargin)
        }

        buttonsBox.snp_makeConstraints { make in
            make.trailing.top.bottom.equalTo(self).inset(Size.margins)
            buttonsWidthConstraint = make.width.equalTo(Size.iconSize.width).constraint
        }
    }
}

extension ProfileLinksView: ProfileViewProtocol {}
