////
///  BuyButtonLinkViewController.swift
//

public protocol BuyButtonLinkControllerDelegate: class {
    func submitBuyButtonLink(url: NSURL)
    func clearBuyButtonLink()
}

public class BuyButtonLinkViewController: UIViewController {
    var screen: BuyButtonLinkScreen { return self.view as! BuyButtonLinkScreen }
    var buyButtonURL: NSURL?
    weak var delegate: BuyButtonLinkControllerDelegate?

    required public init(buyButtonURL: NSURL?) {
        self.buyButtonURL = buyButtonURL
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .Custom
        modalTransitionStyle = .CrossDissolve
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func loadView() {
        let screen = BuyButtonLinkScreen()
        screen.buyButtonURL = buyButtonURL
        screen.delegate = self
        view = screen
    }

}

extension BuyButtonLinkViewController: BuyButtonLinkDelegate {

    public func closeModal() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    public func submitLink(url: NSURL) {
        delegate?.submitBuyButtonLink(url)
    }

    public func clearLink() {
        delegate?.clearBuyButtonLink()
    }

}
