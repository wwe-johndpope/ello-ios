////
///  ElloCollectionView.swift
//

import UIKit


//
// This `contentInset` nonsense is to prevent UIKit from setting the content
// inset when we don't want it to.  Setting `automaticallyAdjustsContentInsets`
// to `false` *should* prevent this from happening, but it doesn't.  So instead,
// the `StreamViewController` sets `elloContentInset`.  If `contentInset` is
// set outside the scope of `uikitOverride` being set, it will be *restored* to
// whatever `elloContentInset` was set to.
//
// UG
//
public class ElloCollectionView: UICollectionView {
    private var uikitOverride = false
    public var elloContentInset: UIEdgeInsets = UIEdgeInsetsZero {
        didSet {
            uikitOverride = true
            contentInset = elloContentInset
            uikitOverride = false
        }
    }
    override public var contentInset: UIEdgeInsets {
        didSet {
            if !uikitOverride {
                uikitOverride = true
                contentInset = elloContentInset
                uikitOverride = false
            }
        }
    }
}
