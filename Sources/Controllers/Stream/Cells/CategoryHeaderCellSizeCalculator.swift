////
///  CategoryHeaderCellSizeCalculator.swift
//

import FutureKit


public class CategoryHeaderCellSizeCalculator: NSObject {
    static let ratio: CGFloat = 320 / 192

    private typealias CellJob = (cellItems: [StreamCellItem], width: CGFloat, columnCount: Int, completion: ElloEmptyCompletion)
    private var cellJobs: [CellJob] = []
    private var screenWidth: CGFloat = 0.0
    private var columnCount: Int = 1
    private var cellItems: [StreamCellItem] = []
    private var completion: ElloEmptyCompletion = {}

    // MARK: Public

    public func processCells(cellItems: [StreamCellItem], withWidth width: CGFloat, columnCount: Int, completion: ElloEmptyCompletion) {
        let job: CellJob = (cellItems: cellItems, width: width, columnCount: columnCount, completion: completion)
        cellJobs.append(job)
        if cellJobs.count == 1 {
            processJob(job)
        }
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
        self.columnCount = job.columnCount
        loadNext()
    }

    private func loadNext() {
        guard !self.cellItems.isEmpty else {
            completion()
            return
        }

        let item = cellItems.removeAtIndex(0)
        let height = screenWidth / CategoryHeaderCellSizeCalculator.ratio
        item.calculatedCellHeights.oneColumn = height
        item.calculatedCellHeights.multiColumn = height
        loadNext()
    }
}
