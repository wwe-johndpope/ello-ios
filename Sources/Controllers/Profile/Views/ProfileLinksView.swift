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
        var links: [(ExternalLink, UIButton)] = []
        var icons: [(ExternalLink, UIButton)] = []
        for externalLink in externalLinks {
            let button = UIButton()
            if let iconURL = externalLink.iconURL {
                iconsBox.addSubview(button)
                iconButtons.append(button)

                button.layer.cornerRadius = Size.iconSize.width / 2
                button.backgroundColor = .greyE5()
                button.snp_makeConstraints { make in
                    make.size.equalTo(Size.iconSize)

                    switch icons.count % 3 {
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

                button.pin_setImageFromURL(iconURL)
                icons.append((externalLink, button))
                prevIcon = button
                if icons.count % 3 == 0 {
                    prevRow = button
                }
            }
            else {
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
                links.append((externalLink, button))
                prevLink = button
            }
        }

        let width: CGFloat = max(0, Size.iconSize.width * CGFloat(min(3, icons.count)) + Size.iconMargins * CGFloat(min(2, icons.count - 1)))
        iconsWidthConstraint.updateOffset(width)
    }
}

extension ProfileLinksView: ProfileViewProtocol {}
