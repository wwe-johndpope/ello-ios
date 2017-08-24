////
///  StreamResponders.swift
//

@objc
protocol StreamCellResponder: class {
    func streamCellTapped(cell: UICollectionViewCell)
}

@objc
protocol SimpleStreamResponder: class {
    func showSimpleStream(boxedEndpoint: BoxedElloAPI, title: String, noResultsMessages: NoResultsMessages?)
}

@objc
protocol StreamImageCellResponder: class {
    func imageTapped(imageView: FLAnimatedImageView, cell: StreamImageCell)
}

@objc
protocol StreamPostTappedResponder: class {
    func postTappedInStream(_ cell: UICollectionViewCell)
}

@objc
protocol StreamEditingResponder: class {
    func cellDoubleTapped(cell: UICollectionViewCell, location: CGPoint)
    func cellDoubleTapped(cell: UICollectionViewCell, post: Post, location: CGPoint)
    func cellLongPressed(cell: UICollectionViewCell)
}

typealias StreamCellItemGenerator = () -> [StreamCellItem]
protocol StreamViewDelegate: class {
    func streamViewCustomLoadFailed() -> Bool
    func streamViewStreamCellItems(jsonables: [JSONAble], defaultGenerator: StreamCellItemGenerator) -> [StreamCellItem]?
    func streamWillPullToRefresh()
    func streamViewDidScroll(scrollView: UIScrollView)
    func streamViewWillBeginDragging(scrollView: UIScrollView)
    func streamViewDidEndDragging(scrollView: UIScrollView, willDecelerate: Bool)
}

@objc
protocol CategoryResponder: class {
    func categoryCellTapped(cell: UICollectionViewCell)
    func categoryTapped(_ category: Category)
}

@objc
protocol SelectedCategoryResponder: class {
    func categoriesSelectionChanged(selection: [Category])
}

@objc
protocol UserResponder: class {
    func userTappedAuthor(cell: UICollectionViewCell)
    func userTappedReposter(cell: UICollectionViewCell)
    func userTapped(user: User)
}

@objc
protocol WebLinkResponder: class {
    func webLinkTapped(path: String, type: ElloURIWrapper, data: String)
}

@objc
protocol GridListToggleDelegate: class {
    func gridListToggled(_ sender: UIButton)
}

@objc
protocol CategoryListCellResponder: class {
    func categoryListCellTapped(slug: String, name: String)
}

@objc
protocol SearchStreamResponder: class {
    func searchFieldChanged(text: String)
}

@objc
protocol AnnouncementCellResponder: class {
    func markAnnouncementAsRead(cell: UICollectionViewCell)
}

@objc
protocol AnnouncementResponder: class {
    func markAnnouncementAsRead(announcement: Announcement)
}

@objc
protocol PostCommentsResponder: class {
    func loadCommentsTapped()
}
