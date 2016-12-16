////
///  AnnouncementCellSizeCalculator.swift
//

public class AnnouncementCellSizeCalculator {
    var originalWidth: CGFloat = 0

    private typealias CellJob = (cellItems: [StreamCellItem], width: CGFloat, completion: ElloEmptyCompletion)
    private var cellJobs: [CellJob] = []
    private var cellItems: [StreamCellItem] = []
    private var completion: ElloEmptyCompletion = {}

    public init() {}

// MARK: Public

    public static func calculateAnnouncementHeight(announcement: Announcement, cellWidth: CGFloat) -> CGFloat {
        let attributedTitle = NSAttributedString(label: announcement.header, style: .BoldWhite)
        let attributedBody = NSAttributedString(label: announcement.body, style: .White)
        let attributedCTA = NSAttributedString(button: announcement.ctaCaption, style: .WhiteUnderlined)

        let textWidth = cellWidth - AnnouncementCell.Size.margins - AnnouncementCell.Size.imageSize - AnnouncementCell.Size.textLeadingMargin - AnnouncementCell.Size.closeButtonSize
        var calcHeight: CGFloat = 0
        calcHeight += AnnouncementCell.Size.margins
        calcHeight += attributedTitle.heightForWidth(textWidth)
        calcHeight += AnnouncementCell.Size.textVerticalMargin
        calcHeight += attributedBody.heightForWidth(textWidth)
        calcHeight += AnnouncementCell.Size.textVerticalMargin
        calcHeight += attributedCTA.heightForWidth(textWidth)
        calcHeight += AnnouncementCell.Size.margins
        return calcHeight
    }

    public func processCells(cellItems: [StreamCellItem], withWidth width: CGFloat, completion: ElloEmptyCompletion) {
        let job: CellJob = (cellItems: cellItems, width: width, completion: completion)
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
        self.originalWidth = job.width
        loadNext()
    }

    private func loadNext() {
        if let item = self.cellItems.safeValue(0) {
            if let announcement = item.jsonable as? Announcement {
                assignCellHeight(AnnouncementCellSizeCalculator.calculateAnnouncementHeight(announcement, cellWidth: originalWidth))
            }
            else {
                assignCellHeight(0)
            }
        }
        else {
            completion()
        }
    }

    private func assignCellHeight(_ height: CGFloat) {
        if let cellItem = self.cellItems.safeValue(0) {
            self.cellItems.removeAtIndex(0)
            cellItem.calculatedCellHeights.oneColumn = height
            cellItem.calculatedCellHeights.multiColumn = height
        }
        loadNext()
    }

}
