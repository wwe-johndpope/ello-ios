////
///  FakeAnnouncementCellSizeCalculator.swift
//

import Ello
import Foundation


public class FakeAnnouncementCellSizeCalculator: AnnouncementCellSizeCalculator {

    override public func processCells(cellItems: [StreamCellItem], withWidth: CGFloat, completion: ElloEmptyCompletion) {
        for item in cellItems {
            item.calculatedCellHeights.oneColumn = AppSetup.Size.calculatorHeight
            item.calculatedCellHeights.multiColumn = AppSetup.Size.calculatorHeight
        }
        completion()
    }
}
