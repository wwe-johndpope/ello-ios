////
///  UIStoryboardExtensions.swift
//

public extension UIStoryboard {

    class func storyboardWithId(identifier: StoryboardIdentifier, storyboardName: String = "Main") -> UIViewController {
        return UIStoryboard(name: storyboardName, bundle: NSBundle(forClass: AppDelegate.self)).instantiateViewControllerWithIdentifier(identifier.rawValue)
    }
}
