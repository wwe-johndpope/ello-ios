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
        static let linkHeight: CGFloat = 26
    }

    public var externalLinks: [ExternalLink] = [] {
        didSet {
            rearrangeLinks()
        }
    }

    private var linksBox = UIView()
    private var iconsBox = UIView()
    private var linkButtons: [UIButton] = []
    private var iconButtons: [UIButton] = []

    private var iconsWidthConstraint: Constraint!
}

extension ProfileLinksView {

    override func style() {
        backgroundColor = .whiteColor()
    }

    override func bindActions() {
    }

    override func setText() {
    }

    override func arrange() {
        addSubview(linksBox)
        addSubview(iconsBox)

        linksBox.snp_makeConstraints { make in
            make.leading.top.bottom.equalTo(self).inset(Size.margins)
            make.trailing.equalTo(iconsBox.snp_leading).offset(-Size.horizLinkButtonMargin)
        }

        iconsBox.snp_makeConstraints { make in
            make.trailing.top.bottom.equalTo(self).inset(Size.margins)
            iconsWidthConstraint = make.width.equalTo(Size.iconSize.width).constraint
        }
    }
}

extension ProfileLinksView {
    func prepareForReuse() {
        externalLinks = []
    }
}

extension ProfileLinksView {
    func rearrangeLinks() {
        for view in linkButtons + iconButtons {
            view.removeFromSuperview()
        }
        linkButtons = []
        iconButtons = []

        var prevLink: UIButton?
        var prevIcon: UIButton?
        var prevRow: UIButton?
        var iconsCount = 0
        for externalLink in externalLinks {
            if externalLink.iconURL != nil {
                prevIcon = addIconButton(externalLink, iconsCount: iconsCount, prevIcon: prevIcon, prevRow: prevRow)
                iconsCount += 1
                if iconsCount % 3 == 0 {
                    prevRow = prevIcon
                }
            }
            else {
                prevLink = addLinkButton(externalLink, prevLink: prevLink)
            }
        }

        let width: CGFloat = max(0, Size.iconSize.width * CGFloat(min(3, iconsCount)) + Size.iconMargins * CGFloat(min(2, iconsCount - 1)))
        iconsWidthConstraint.updateOffset(width)
    }

    private func addIconButton(externalLink: ExternalLink, iconsCount: Int, prevIcon: UIButton?, prevRow: UIView?) -> UIButton {
        let button = UIButton()
        iconsBox.addSubview(button)
        iconButtons.append(button)

        button.layer.cornerRadius = Size.iconSize.width / 2
        button.backgroundColor = .greyE5()
        button.snp_makeConstraints { make in
            make.size.equalTo(Size.iconSize)

            switch iconsCount % 3 {
            case 0:
                make.trailing.equalTo(iconsBox)
            default:
                make.trailing.equalTo(prevIcon!.snp_leading).offset(-Size.iconMargins)
            }

            if let prevRow = prevRow {
                make.top.equalTo(prevRow.snp_bottom).offset(Size.iconMargins)
            }
            else {
                make.top.equalTo(iconsBox)
            }
        }

        button.pin_setImageFromURL(externalLink.iconURL!)
        return button
    }

    private func addLinkButton(externalLink: ExternalLink, prevLink: UIButton?) -> UIButton {
        let button = UIButton()
        linksBox.addSubview(button)
        linkButtons.append(button)

        button.snp_makeConstraints { make in
            make.leading.trailing.equalTo(linksBox)

            if let prevLink = prevLink {
                make.top.equalTo(prevLink.snp_bottom).offset(Size.verticalLinkMargin)
            }
            else {
                make.top.equalTo(linksBox)
            }
        }

        let attrs: [String: AnyObject] = [
            NSFontAttributeName: UIFont.defaultFont(),
            NSForegroundColorAttributeName: UIColor.grey6(),
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
        ]
        let highlightedAttrs: [String: AnyObject] = [
            NSFontAttributeName: UIFont.defaultFont(),
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
        ]
        button.setAttributedTitle(NSAttributedString(string: externalLink.text, attributes: attrs), forState: .Normal)
        button.setAttributedTitle(NSAttributedString(string: externalLink.text, attributes: highlightedAttrs), forState: .Highlighted)
        button.contentHorizontalAlignment = .Left
        return button
    }
}

extension ProfileLinksView: ProfileViewProtocol {}
