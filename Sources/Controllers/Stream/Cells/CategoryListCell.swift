//
//  CategoryListCell.swift
//  Ello
//
//  Created by Colin Gray on 6/14/2016.
//  Copyright (c) 2016 Ello. All rights reserved.
//

import SnapKit

public class CategoryListCell: UICollectionViewCell {
    static let reuseIdentifier = "CategoryListCell"
    weak var discoverCategoryPickerDelegate: DiscoverCategoryPickerDelegate?
    private var buttonEndpointLookup: [UIButton: ElloAPI] = [:]

    struct Size {
        static let sideMargins: CGFloat = 15
        static let spacing: CGFloat = 15
    }

    var categoriesInfo: [(title: String, endpoint: ElloAPI, selected: Bool)] = [] {
        didSet {
            let changed: Bool = (categoriesInfo.count != oldValue.count) || oldValue.enumerate().any { (index, info) in
                return info.title != categoriesInfo[index].title || info.selected != categoriesInfo[index].selected || info.endpoint.path != categoriesInfo[index].endpoint.path
            }
            if changed {
                updateCategoryViews()
            }
        }
    }
    private var categoryButtons: [UIButton] = []
    private var allCategoriesButton = UIButton()

    private class func buttonTitle(category: String, selected: Bool) -> NSAttributedString {
        var attrs: [String: AnyObject] = [
            NSFontAttributeName: UIFont.defaultFont(),
        ]
        if selected {
            attrs[NSForegroundColorAttributeName] = UIColor.blackColor()
            attrs[NSUnderlineStyleAttributeName] = NSUnderlineStyle.StyleSingle.rawValue
        }
        else {
            attrs[NSForegroundColorAttributeName] = UIColor.greyA()
        }
        let attributedString = NSAttributedString(string: category, attributes: attrs)
        return attributedString
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        style()
        bindActions()
        arrange()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func style() {
        backgroundColor = .whiteColor()
        allCategoriesButton.setImage(.DotsLight, imageStyle: .Normal, forState: .Normal)
    }

    private func bindActions() {
        allCategoriesButton.addTarget(self, action: #selector(allTapped), forControlEvents: .TouchUpInside)
    }

    private func arrange() {
        addSubview(allCategoriesButton)

        allCategoriesButton.snp_makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).offset(-Size.sideMargins).priorityRequired()
        }
    }

    @objc
    func valueChanged(button: UIButton) {
        guard let endpoint = buttonEndpointLookup[button] else { return }
        discoverCategoryPickerDelegate?.discoverCategoryTapped(endpoint)
    }

    @objc
    func allTapped() {
        discoverCategoryPickerDelegate?.discoverAllCategoriesTapped()
    }

    private func updateCategoryViews() {
        for view in categoryButtons {
            view.removeFromSuperview()
        }
        buttonEndpointLookup = [:]

        categoryButtons = categoriesInfo.map { (category, endpoint, selected) in
            let button = UIButton()
            buttonEndpointLookup[button] = endpoint
            button.backgroundColor = .clearColor()
            button.addTarget(self, action: #selector(valueChanged(_:)), forControlEvents: .TouchUpInside)
            let attributedString = CategoryListCell.buttonTitle(category, selected: selected)
            button.setAttributedTitle(attributedString, forState: UIControlState.Normal)

            return button
        }

        var prevView: UIView? = nil
        for view in categoryButtons {
            contentView.addSubview(view)

            view.snp_makeConstraints { make in
                make.centerY.equalTo(contentView)

                if let prevView = prevView {
                    make.leading.equalTo(prevView.snp_trailing).offset(Size.spacing)
                }
                else {
                    make.leading.equalTo(contentView.snp_leading).offset(Size.sideMargins)
                }
            }

            prevView = view
        }

        layoutIfNeeded()

        for view in categoryButtons {
            if view.frame.maxX > allCategoriesButton.frame.minX {
                view.hidden = true
            }
        }
    }

}
