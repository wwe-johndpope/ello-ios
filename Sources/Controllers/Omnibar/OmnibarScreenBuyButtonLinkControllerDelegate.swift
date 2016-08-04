////
///  OmnibarScreenBuyButtonLinkControllerDelegate.swift
//

extension OmnibarScreen: BuyButtonLinkControllerDelegate {

    public func submitBuyButtonLink(url: NSURL) {
        buyButtonURL = url
        regionsTableView.reloadData()
    }

    public func clearBuyButtonLink() {
        buyButtonURL = nil
        regionsTableView.reloadData()
    }

}
