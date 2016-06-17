//
//  DiscoverAllCategoriesViewController.swift
//  Ello
//
//  Created by Colin Gray on 6/17/2016.
//  Copyright (c) 2016 Ello. All rights reserved.
//

public class DiscoverAllCategoriesViewController: StreamableViewController {
    var screen: DiscoverAllCategoriesScreen!

    required public init() {
        super.init(nibName: nil, bundle: nil)

        title = InterfaceString.Discover.Categories
        elloNavigationItem.title = title
        streamViewController.streamKind = .Categories
        streamViewController.customStreamCellItems = { jsonables, defaultItems in
            var items: [StreamCellItem] = CategoryList.metaCategories().map { StreamCellItem(jsonable: $0, type: .Category) }
            if let categories = jsonables as? [Category] {
                let sortedCategories = categories
                    .filter { $0.level == .Primary }
                    .sort { $0.order < $1.order }
                for category in sortedCategories {
                    items.append(StreamCellItem(jsonable: category, type: .Category))
                }
            }
            return items
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
