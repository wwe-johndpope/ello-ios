////
///  ElloCollectionView.swift
//

import UIKit


public class ElloCollectionView: UICollectionView {

    private let queue = NSOperationQueue()

    public func reload(reloadPaths: [NSIndexPath]) {
        queue.maxConcurrentOperationCount = 1

        let operation = AsyncOperation(block: { [weak self] done in
            guard let sself = self else { return }
            inForeground {
                sself.performBatchUpdates({
                    sself.reloadItemsAtIndexPaths(reloadPaths)
                    }, completion: { _ in
                        done()
                })
            }
        })
        queue.addOperation(operation)
    }
}
