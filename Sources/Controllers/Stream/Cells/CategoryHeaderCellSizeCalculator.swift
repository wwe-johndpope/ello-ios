////
///  CategoryHeaderCellSizeCalculator.swift
//

import FutureKit


public class CategoryHeaderCellSizeCalculator: NSObject {
    static let ratio: CGFloat = 320 / 192

    private typealias CellJob = (cellItems: [StreamCellItem], width: CGFloat, completion: ElloEmptyCompletion)
    private var cellJobs: [CellJob] = []
    private var screenWidth: CGFloat = 0.0
    private var cellItems: [StreamCellItem] = []
    private var completion: ElloEmptyCompletion = {}

    // MARK: Public

    public func processCells(cellItems: [StreamCellItem], withWidth width: CGFloat, completion: ElloEmptyCompletion) {
        let job: CellJob = (cellItems: cellItems, width: width, completion: completion)
        cellJobs.append(job)
        if cellJobs.count == 1 {
            processJob(job)
        }
    }

    public static func calculateCategoryHeight(category: Category, screenWidth: CGFloat) -> CGFloat {
        let config = CategoryHeaderCell.Config(category: category)
        return CategoryHeaderCellSizeCalculator.calculateHeight(config, screenWidth: screenWidth)
    }

    public static func calculatePagePromotionalHeight(pagePromotional: PagePromotional, screenWidth: CGFloat) -> CGFloat {
        let config = CategoryHeaderCell.Config(pagePromotional: pagePromotional)
        return CategoryHeaderCellSizeCalculator.calculateHeight(config, screenWidth: screenWidth)
    }

    public static func calculateHeight(config: CategoryHeaderCell.Config, screenWidth: CGFloat) -> CGFloat {
        var calcHeight: CGFloat = 0
        let textWidth = screenWidth - 2 * CategoryHeaderCell.Size.defaultMargin
        let boundingSize = CGSize(width: textWidth, height: CGFloat.max)

        let attributedTitle = config.attributedTitle
        calcHeight += CategoryHeaderCell.Size.topMargin
        calcHeight += attributedTitle.heightForWidth(textWidth)

        if let attributedBody = config.attributedBody {
            calcHeight += CategoryHeaderCell.Size.bodyMargin
            calcHeight += attributedBody.heightForWidth(textWidth)
        }

        var ctaSize: CGSize = .zero
        var postedBySize: CGSize = .zero
        if let attributedCallToAction = config.attributedCallToAction {
            ctaSize = attributedCallToAction.boundingRectWithSize(boundingSize, options: [], context: nil).size.integral
        }

        if let attributedPostedBy = config.attributedPostedBy {
            postedBySize = attributedPostedBy.boundingRectWithSize(boundingSize, options: [], context: nil).size.integral
        }

        calcHeight += CategoryHeaderCell.Size.bodyMargin
        if ctaSize.width + postedBySize.width > textWidth {
            calcHeight += ctaSize.height + CategoryHeaderCell.Size.stackedMargin + postedBySize.height
        }
        else {
            calcHeight += max(ctaSize.height, postedBySize.height)
        }

        calcHeight += CategoryHeaderCell.Size.defaultMargin
        return calcHeight
    }

    // MARK: Private

    private func processJob(job: CellJob) {
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
        self.screenWidth = job.width
        loadNext()
    }

    private func loadNext() {
        guard !self.cellItems.isEmpty else {
            completion()
            return
        }

        let item = cellItems.removeAtIndex(0)
        let minHeight = ceil(screenWidth / CategoryHeaderCellSizeCalculator.ratio)
        var calcHeight: CGFloat = 0
        if let category = item.jsonable as? Category {
            calcHeight += CategoryHeaderCellSizeCalculator.calculateCategoryHeight(category, screenWidth: screenWidth)
        }
        else if let pagePromotional = item.jsonable as? PagePromotional {
            calcHeight += CategoryHeaderCellSizeCalculator.calculatePagePromotionalHeight(pagePromotional, screenWidth: screenWidth)
        }

        let height = max(minHeight, calcHeight)
        item.calculatedCellHeights.oneColumn = height
        item.calculatedCellHeights.multiColumn = height
        loadNext()
    }
}
