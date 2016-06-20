//
//  SeeAllCategoriesCellPresenter.swift
//  Ello
//
//  Created by Colin Gray on 6/17/2016.
//  Copyright (c) 2016 Ello. All rights reserved.
//

public struct SeeAllCategoriesCellPresenter {

    static func configure(
        cell: UICollectionViewCell,
        streamCellItem: StreamCellItem,
        streamKind: StreamKind,
        indexPath: NSIndexPath,
        currentUser: User?)
    {
        if let cell = cell as? CategoryCell {
            cell.title = InterfaceString.Discover.SeeAllCategories
            cell.highlight = .White
        }
    }

}
