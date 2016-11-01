////
///  FakeProfileHeaderCellSizeCalculator.swift
//

import Ello


public class FakeProfileHeaderCellSizeCalculator: ProfileHeaderCellSizeCalculator {

    override public func processCells(cellItems: [StreamCellItem], withWidth: CGFloat, columnCount: Int, completion: ElloEmptyCompletion) {
        for item in cellItems {
            item.calculatedCellHeights.oneColumn = AppSetup.Size.calculatorHeight
            item.calculatedCellHeights.multiColumn = AppSetup.Size.calculatorHeight
        }
        completion()
    }
}
