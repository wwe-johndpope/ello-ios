////
///  ProfileHeaderCellSizeCalculator.swift
//

import FutureKit


public class ProfileHeaderCellSizeCalculator: NSObject {
    static let ratio: CGFloat = 16 / 9
    let webView: UIWebView

    private var maxWidth: CGFloat = 0.0
    private typealias CellJob = (cellItems: [StreamCellItem], width: CGFloat, columnCount: Int, completion: ElloEmptyCompletion)
    private var cellJobs: [CellJob] = []
    private var cellItems: [StreamCellItem] = []
    private var completion: ElloEmptyCompletion = {}

    required public init(webView: UIWebView) {
        self.webView = webView
        super.init()
        webView.delegate = self
    }

// MARK: Public

    public func processCells(cellItems: [StreamCellItem], withWidth width: CGFloat, columnCount: Int, completion: ElloEmptyCompletion) {
        let job: CellJob = (cellItems: cellItems, width: width, columnCount: columnCount, completion: completion)
        cellJobs.append(job)
        if cellJobs.count == 1 {
            processJob(job)
        }
    }

}

private extension ProfileHeaderCellSizeCalculator {

    func processJob(job: CellJob) {

        self.completion = {
            if self.cellJobs.count > 0 {
                self.cellJobs.removeAtIndex(0)
            }
            job.completion()
            if let nextJob = self.cellJobs.safeValue(0) {
                self.processJob(nextJob)
            }
        }
        self.cellItems = job.cellItems
        self.maxWidth = job.width
        loadNext()
    }

    func loadNext() {

        if let item = cellItems.safeValue(0) {
            if item.jsonable is User {
                calculateAggregateHeights(item)
            }
            else {
                assignCellHeight(0)
            }
        }
        else {
            completion()
        }
    }

    func assignCellHeight(height: CGFloat) {

        if let cellItem = cellItems.safeValue(0) {
            self.cellItems.removeAtIndex(0)
            cellItem.calculatedWebHeight = height
            cellItem.calculatedOneColumnCellHeight = height
            cellItem.calculatedMultiColumnCellHeight = height
        }
        loadNext()
    }

    func calculateAggregateHeights(item: StreamCellItem) {
        var totalHeight: CGFloat = 0

        let futures = [
            ProfileStatsSizeCalculator().calculate(item),
            ProfileAvatarSizeCalculator().calculate(item),
            ProfileBioSizeCalculator().calculate(item),
            ProfileLinksSizeCalculator().calculate(item),
            ProfileNamesSizeCalculator().calculate(item, maxWidth: maxWidth),
            ProfileTotalCountSizeCalculator().calculate(item)
        ]

        let done = after(futures.count) {
            self.assignCellHeight(totalHeight)
        }

        for future in futures {
            future
                .onSuccess { height in
                    totalHeight += height
                    done()
                }
                .onFailorCancel { _ in done() }
        }
    }
}

extension ProfileHeaderCellSizeCalculator: UIWebViewDelegate {

    public func webViewDidFinishLoad(webView: UIWebView) {
        let webViewHeight = webView.windowContentSize()?.height ?? 0
        assignCellHeight(webViewHeight)
    }

}
