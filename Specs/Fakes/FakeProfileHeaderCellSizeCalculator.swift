////
///  FakeProfileHeaderCellSizeCalculator.swift
//

import Ello


public class FakeProfileHeaderCellSizeCalculator: ProfileHeaderCellSizeCalculator {

    override public func processCells(cellItems:[StreamCellItem], withWidth: CGFloat, columnCount: Int, completion:ElloEmptyCompletion) {
        self.completion = completion
        self.cellItems = cellItems
        for item in cellItems {
            item.calculatedOneColumnCellHeight = AppSetup.Size.calculatorHeight
            item.calculatedMultiColumnCellHeight = AppSetup.Size.calculatorHeight
        }
        completion()
    }
}
