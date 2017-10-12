////
///  DrawerPopControl.swift
//

class DrawerPopControl: UIControl {
    var presentingController: UIViewController?

    init() {
        super.init(frame: .zero)
        addTarget(self, action: #selector(DrawerPopControl.pop), for: .touchDown)
    }

    @objc
    func pop() {
        presentingController?.dismiss(animated: true, completion: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
