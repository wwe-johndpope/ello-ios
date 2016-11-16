////
///  UIBarButtonItem.swift
//

extension UIBarButtonItem {

    class func searchItem(controller controller: BaseElloViewController) -> UIBarButtonItem {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 44))
        button.addTarget(controller, action: #selector(BaseElloViewController.searchButtonTapped), forControlEvents: .TouchUpInside)
        button.setImage(.Search, imageStyle: .Normal, forState: .Normal)

        return UIBarButtonItem(customView: button)
    }

    class func gridListItem(delegate delegate: GridListToggleDelegate, isGridView: Bool) -> UIBarButtonItem {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 44))
        let isGridView = isGridView
        button.addTarget(delegate, action: #selector(GridListToggleDelegate.gridListToggled(_:)), forControlEvents: .TouchUpInside)

        let item = UIBarButtonItem(customView: button)
        item.setImage(isGridView: isGridView)
        return item
    }

    class func backChevron(withController controller: BaseElloViewController) -> UIBarButtonItem {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 44))
        button.setImage(.AngleBracket, imageStyle: .Normal, forState: .Normal)
        // rotate 180 degrees to flip
        button.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        button.addTarget(controller, action: #selector(BaseElloViewController.backTapped), forControlEvents: .TouchUpInside)

        return UIBarButtonItem(customView: button)
    }

    class func backChevronWithTarget(target: AnyObject, action: Selector) -> UIBarButtonItem {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 44))
        button.setImage(.AngleBracket, imageStyle: .Normal, forState: .Normal)
        // rotate 180 degrees to flip
        button.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)

        return UIBarButtonItem(customView: button)
    }

    class func closeButton(target target: AnyObject, action: Selector) -> UIBarButtonItem {
        let closeItem = UIBarButtonItem(image: InterfaceImage.X.normalImage, style: UIBarButtonItemStyle.Plain, target: target, action: action)
        return closeItem
    }

    class func spacer(width width: CGFloat) -> UIBarButtonItem {
        let spacer = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        spacer.width = width
        return spacer
    }

    convenience init(image: InterfaceImage, target: AnyObject, action: Selector) {
        let frame = CGRect(x: 0, y: 0, width: 36.0, height: 44.0)
        let button = UIButton(frame: frame)
        button.setImage(image, imageStyle: .Normal, forState: .Normal)
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)

        self.init(customView: button)
    }

    func setImage(isGridView isGridView: Bool) {
        guard let button = customView as? UIButton else { return }

        button.setImage(isGridView ? .ListView : .GridView, imageStyle: .Normal, forState: .Normal)
    }

}
