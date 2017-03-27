////
///  StreamLoadMoreCommentsCell.swift
//

import SnapKit


class StreamLoadMoreCommentsCell: UICollectionViewCell {
    static let reuseIdentifier = "StreamLoadMoreCommentsCell"

    struct Size {
        static let height: CGFloat = 60
        static let margin: CGFloat = 15
    }

    let button = StyledButton(style: .RoundedGray)

    override init(frame: CGRect) {
        super.init(frame: frame)

        style()
        arrange()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func style() {
        button.setTitle(InterfaceString.Post.LoadMoreComments, for: .normal)
    }

    fileprivate func arrange() {
        contentView.addSubview(button)

        button.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(Size.margin)
        }
    }

}
