//
//  CategoryCell.swift
//  Ello
//
//  Created by Colin Gray on 6/17/2016.
//  Copyright (c) 2016 Ello. All rights reserved.
//

import SnapKit

public class CategoryCell: UICollectionViewCell {
    static let reuseIdentifier = "CategoryCell"

    enum Highlight {
        case Gray
        case White

        var color: UIColor {
            switch self {
            case .Gray: return .greyF2()
            case .White: return .whiteColor()
            }
        }
    }

    struct Size {
        static let sideMargins: CGFloat = 15
        static let lineHeight: CGFloat = 1
    }

    var category: String {
        set { label.text = newValue }
        get { return label.text ?? "" }
    }
    var highlight: Highlight = .White {
        didSet {
            colorFillView.backgroundColor = highlight.color
        }
    }

    private let label = ElloLabel()
    private let colorFillView = UIView()

    override public init(frame: CGRect) {
        super.init(frame: frame)

        arrange()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func arrange() {
        colorFillView.snp_makeConstraints { make in
            make.edges.equalTo(contentView) // .inset(UIEdgeInsets(bottom: Size.lineHeight))
        }
        label.snp_makeConstraints { make in
            make.edges.equalTo(contentView) // .inset(UIEdgeInsets(left: Size.sideMargins))
        }
    }
}
