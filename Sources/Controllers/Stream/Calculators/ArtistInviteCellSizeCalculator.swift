////
///  ArtistInviteCellSizeCalculator.swift
//

class ArtistInviteCellSizeCalculator: NSObject {
    enum CellType {
        case bubble
    }

    let webView: UIWebView
    fileprivate typealias CellJob = (cellItems: [StreamCellItem], width: CGFloat, type: CellType, completion: Block)
    fileprivate var cellJobs: [CellJob] = []
    fileprivate var cellItems: [StreamCellItem] = []
    fileprivate var cellType: CellType = .bubble
    fileprivate var completion: Block = {}
    fileprivate var maxWidth: CGFloat = 0

    init(webView: UIWebView = UIWebView()) {
        self.webView = webView
        super.init()
        self.webView.delegate = self
    }

// MARK: Public

    func processCells(_ cellItems: [StreamCellItem], withWidth width: CGFloat, type: CellType, completion: @escaping Block) {
        guard cellItems.count > 0 else {
            completion()
            return
        }

        let job: CellJob = (cellItems: cellItems, width: width, type: type, completion: completion)
        cellJobs.append(job)
        if cellJobs.count == 1 {
            processJob(job)
        }
    }

// MARK: Private

    fileprivate func processJob(_ job: CellJob) {
        self.completion = {
            if self.cellJobs.count > 0 {
                self.cellJobs.remove(at: 0)
            }
            job.completion()
            if let nextJob = self.cellJobs.safeValue(0) {
                self.processJob(nextJob)
            }
        }

        cellItems = job.cellItems
        cellType = job.type
        maxWidth = job.width
        webView.frame = webView.frame.with(width: maxWidth)

        loadNext()
    }

    fileprivate func loadNext() {
        guard !self.cellItems.isEmpty else {
            completion()
            return
        }

        guard
            let artistInvite = cellItems[0].jsonable as? ArtistInvite
        else {
            cellItems.remove(at: 0)
            loadNext()
            return
        }

        let html = StreamTextCellHTML.postHTML(artistInvite.longDescription)
        webView.loadHTMLString(html, baseURL: URL(string: "/"))
    }

    fileprivate func assignCellHeight(_ height: CGFloat) {
        let cellItem = cellItems.remove(at: 0)

        switch cellType {
        case .bubble:
            assignBubbleCellHeight(cellItem, height)
        }
        loadNext()
    }

    fileprivate func assignBubbleCellHeight(_ cellItem: StreamCellItem, _ height: CGFloat) {
        var totalHeight = height
        totalHeight += ArtistInviteBubbleCell.Size.bubbleMargins.top
        totalHeight += ArtistInviteBubbleCell.Size.headerImageHeight
        totalHeight += ArtistInviteBubbleCell.Size.infoTotalHeight
        totalHeight += (height > 0 ? ArtistInviteBubbleCell.Size.descriptionMargins.bottom : 0)
        totalHeight += ArtistInviteBubbleCell.Size.bubbleMargins.bottom

        cellItem.calculatedCellHeights.webContent = totalHeight
        cellItem.calculatedCellHeights.oneColumn = totalHeight
        cellItem.calculatedCellHeights.multiColumn = totalHeight
    }
}

extension ArtistInviteCellSizeCalculator: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let textHeight = webView.windowContentSize()?.height
        assignCellHeight(textHeight ?? 0)
    }
}
