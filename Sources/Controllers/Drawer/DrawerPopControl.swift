////
///  DrawerPopControl.swift
//

public class DrawerPopControl: UIControl {
    var presentingController: UIViewController?

    public init() {
        super.init(frame: .zero)
        addTarget(self, action: #selector(DrawerPopControl.pop), forControlEvents: .TouchDown)
    }

    func pop() {
        presentingController?.dismissViewControllerAnimated(true, completion: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
