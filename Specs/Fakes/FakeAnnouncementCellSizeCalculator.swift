////
///  FakeAnnouncementCellSizeCalculator.swift
//

@testable import Ello


class FakeAnnouncementCellSizeCalculator: AnnouncementCellSizeCalculator {

    override func processCells(_ cellItems: [StreamCellItem], withWidth: CGFloat, completion: @escaping Block) {
        for item in cellItems {
            item.calculatedCellHeights.oneColumn = ElloConfiguration.Size.calculatorHeight
            item.calculatedCellHeights.multiColumn = ElloConfiguration.Size.calculatorHeight
        }
        completion()
    }
}
