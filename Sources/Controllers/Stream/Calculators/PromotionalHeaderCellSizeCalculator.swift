////
///  PromotionalHeaderCellSizeCalculator.swift
//


class PromotionalHeaderCellSizeCalculator: NSObject {
    static let ratio: CGFloat = 320 / 192

    let webView: UIWebView

    private typealias CellJob = (cellItems: [StreamCellItem], width: CGFloat, completion: Block)
    private var cellJobs: [CellJob] = []
    private var cellWidth: CGFloat = 0.0
    private var cellItems: [StreamCellItem] = []
    private var cellItem: StreamCellItem?
    private var completion: Block = {}

    init(webView: UIWebView = ElloWebView()) {
        self.webView = webView
        super.init()
        self.webView.delegate = self
    }

    func processCells(_ cellItems: [StreamCellItem], withWidth width: CGFloat, completion: @escaping Block) {
        guard cellItems.count > 0 else {
            completion()
            return
        }

        let job: CellJob = (cellItems: cellItems, width: width, completion: completion)
        cellJobs.append(job)
        if cellJobs.count == 1 {
            processJob(job)
        }
    }

    static func calculateCategoryHeight(_ category: Category, cellWidth: CGFloat) -> CGFloat {
        let config = PromotionalHeaderCell.Config(category: category)
        return PromotionalHeaderCellSizeCalculator.calculateHeight(config, htmlHeight: nil, cellWidth: cellWidth)
    }

    static func calculatePagePromotionalHeight(_ pagePromotional: PagePromotional, htmlHeight: CGFloat?, cellWidth: CGFloat) -> CGFloat {
        let config = PromotionalHeaderCell.Config(pagePromotional: pagePromotional)
        return PromotionalHeaderCellSizeCalculator.calculateHeight(config, htmlHeight: htmlHeight, cellWidth: cellWidth)
    }

    static func calculateHeight(_ config: PromotionalHeaderCell.Config, htmlHeight: CGFloat?, cellWidth: CGFloat) -> CGFloat {
        var calcHeight: CGFloat = 0
        let textWidth = cellWidth - 2 * PromotionalHeaderCell.Size.defaultMargin
        let boundingSize = CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude)

        let attributedTitle = config.attributedTitle
        calcHeight += PromotionalHeaderCell.Size.topMargin
        calcHeight += attributedTitle.heightForWidth(textWidth)

        if let htmlHeight = htmlHeight, config.hasHtml {
            calcHeight += htmlHeight
        }
        else if let attributedBody = config.attributedBody, !config.hasHtml {
            calcHeight += PromotionalHeaderCell.Size.bodySpacing
            calcHeight += attributedBody.heightForWidth(textWidth)
        }

        var ctaSize: CGSize = .zero
        var postedBySize: CGSize = .zero
        if let attributedCallToAction = config.attributedCallToAction {
            ctaSize = attributedCallToAction.boundingRect(with: boundingSize, options: [], context: nil).size.integral
        }

        if let attributedPostedBy = config.attributedPostedBy {
            postedBySize = attributedPostedBy.boundingRect(with: boundingSize, options: [], context: nil).size.integral
        }

        calcHeight += PromotionalHeaderCell.Size.bodySpacing
        if ctaSize.width + postedBySize.width > textWidth {
            calcHeight += ctaSize.height + PromotionalHeaderCell.Size.stackedMargin + postedBySize.height
        }
        else {
            calcHeight += max(ctaSize.height, postedBySize.height)
        }

        calcHeight += PromotionalHeaderCell.Size.defaultMargin
        return calcHeight
    }

    // MARK: Private

    private func processJob(_ job: CellJob) {
        self.completion = {
            if self.cellJobs.count > 0 {
                self.cellJobs.remove(at: 0)
            }
            job.completion()
            if let nextJob = self.cellJobs.safeValue(0) {
                self.processJob(nextJob)
            }
        }
        self.cellItems = job.cellItems
        self.cellWidth = job.width
        var webWidth = job.width
        webWidth -= 2 * PromotionalHeaderCell.Size.defaultMargin
        webView.frame = webView.frame.with(width: webWidth)
        loadNext()
    }

    private func loadNext() {
        guard !self.cellItems.isEmpty else {
            self.cellItem = nil
            completion()
            return
        }

        let item = cellItems.remove(at: 0)
        self.cellItem = item

        let minHeight = ceil(cellWidth / PromotionalHeaderCellSizeCalculator.ratio)
        var calcHeight: CGFloat?
        if let category = item.jsonable as? Category {
            calcHeight = PromotionalHeaderCellSizeCalculator.calculateCategoryHeight(category, cellWidth: cellWidth)
        }
        else if let pagePromotional = item.jsonable as? PagePromotional {
            if pagePromotional.isCategory {
                calcHeight = PromotionalHeaderCellSizeCalculator.calculatePagePromotionalHeight(pagePromotional, htmlHeight: nil, cellWidth: cellWidth)
            }
            else {
                let text = pagePromotional.subheader
                let html = StreamTextCellHTML.editorialHTML(text)
                webView.loadHTMLString(html, baseURL: URL(string: "/"))
            }
        }
        else {
            loadNext()
            return
        }

        if let calcHeight = calcHeight {
            let height = max(minHeight, calcHeight)
            assignHeight(height)
        }
    }

    private func assignHeight(_ height: CGFloat) {
        guard let item = cellItem else { return }
        item.calculatedCellHeights.oneColumn = height
        item.calculatedCellHeights.multiColumn = height
        loadNext()
    }
}

extension PromotionalHeaderCellSizeCalculator: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        guard
            let item = cellItem,
            let pagePromotional = item.jsonable as? PagePromotional
        else { return }

        let textHeight = webView.windowContentSize()?.height
        let calcHeight = PromotionalHeaderCellSizeCalculator.calculatePagePromotionalHeight(pagePromotional, htmlHeight: textHeight, cellWidth: cellWidth)
        assignHeight(calcHeight)
    }
}
