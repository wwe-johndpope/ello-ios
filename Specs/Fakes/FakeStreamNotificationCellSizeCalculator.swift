////
///  FakeStreamNotificationCellSizeCalculator.swift
//

@testable import Ello
import Foundation


class FakeStreamNotificationCellSizeCalculator: StreamNotificationCellSizeCalculator {

    override func processCells(_ cellItems: [StreamCellItem], withWidth: CGFloat, completion: @escaping Block) {
        for item in cellItems {
            item.calculatedCellHeights.oneColumn = ElloConfiguration.Size.calculatorHeight
            item.calculatedCellHeights.multiColumn = ElloConfiguration.Size.calculatorHeight
        }
        completion()
    }
}
