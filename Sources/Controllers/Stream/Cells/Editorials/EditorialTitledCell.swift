////
///  EditorialTitledCell.swift
//

class EditorialTitledCell: EditorialCell {
    let titleLabel = StyledLabel(style: .editorialHeaderWhite)
    let subtitleLabel = StyledLabel(style: .editorialCaptionWhite)

    enum TitlePlacement {
        case `default`
        case inStream
    }
    var titlePlacement: TitlePlacement = .default {
        didSet {
            let top: CGFloat
            switch titlePlacement {
            case .default:
                top = Size.defaultMargin.top
            case .inStream:
                top = Size.postStreamLabelMargin
            }

            titleLabel.snp.updateConstraints { make in
                make.top.equalTo(editorialContentView).offset(top)
            }
        }
    }

    override func style() {
        super.style()
        titleLabel.numberOfLines = 0
        subtitleLabel.numberOfLines = 0
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titlePlacement = .default
    }

    override func updateConfig() {
        super.updateConfig()
        titleLabel.text = config.title
        subtitleLabel.text = config.subtitle
    }

    override func arrange() {
        super.arrange()

        editorialContentView.addSubview(titleLabel)
        editorialContentView.addSubview(subtitleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(editorialContentView).inset(Size.defaultMargin)
        }
    }

}
