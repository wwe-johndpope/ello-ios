////
///  AlertCellPresenter.swift
//

import UIKit

struct AlertCellPresenter {

    static func configureCell(cell: AlertCell, type: AlertType = .Normal) {
        cell.background.layer.borderColor = nil
        cell.background.layer.cornerRadius = 0
        cell.input.hidden = true
        cell.okButton.hidden = true
        cell.cancelButton.hidden = true
        cell.contentView.backgroundColor = type.backgroundColor
    }

    static func configureForWhiteAction(cell: AlertCell, type: AlertType, action: AlertAction, textAlignment: NSTextAlignment) {
        configureCell(cell, type: type)

        cell.label.setLabelText(action.title, color: .blackColor(), alignment: textAlignment)
        cell.background.backgroundColor = .whiteColor()
    }

    static func configureForLightAction(cell: AlertCell, type: AlertType, action: AlertAction, textAlignment: NSTextAlignment) {
        configureCell(cell, type: type)

        cell.label.setLabelText(action.title, color: .grey6(), alignment: textAlignment)
        cell.background.backgroundColor = .greyE5()
    }

    static func configureForDarkAction(cell: AlertCell, type: AlertType, action: AlertAction, textAlignment: NSTextAlignment) {
        configureCell(cell, type: type)

        cell.label.setLabelText(action.title, alignment: textAlignment)
        cell.background.backgroundColor = .blackColor()
    }

    static func configureForGreenAction(cell: AlertCell, type: AlertType, action: AlertAction, textAlignment: NSTextAlignment) {
        configureCell(cell, type: type)

        cell.label.setLabelText(action.title, alignment: textAlignment)
        cell.background.backgroundColor = .greenD1()
        cell.background.layer.cornerRadius = 5
    }

    static func configureForRoundedGrayFillAction(cell: AlertCell, type: AlertType, action: AlertAction, textAlignment: NSTextAlignment) {
        configureCell(cell, type: type)

        cell.label.setLabelText(action.title, color: .grey6(), alignment: textAlignment)
        cell.background.backgroundColor = .greyE5()
        cell.background.layer.cornerRadius = 5
    }

    static func configureForInputAction(cell: AlertCell, type: AlertType, action: AlertAction) {
        configureCell(cell, type: type)

        cell.input.hidden = false
        cell.input.placeholder = action.title

        cell.input.keyboardAppearance = .Dark
        cell.input.keyboardType = .Default
        cell.input.autocapitalizationType = .Sentences
        cell.input.autocorrectionType = .Default
        cell.input.spellCheckingType = .Default
        cell.input.enablesReturnKeyAutomatically = true
        cell.input.returnKeyType = .Default

        cell.background.backgroundColor = .whiteColor()
    }

    static func configureForURLAction(cell: AlertCell, type: AlertType, action: AlertAction, textAlignment: NSTextAlignment) {
        configureForInputAction(cell, type: type, action: action)

        cell.input.keyboardType = .URL
        cell.input.autocapitalizationType = .None
        cell.input.autocorrectionType = .No
        cell.input.spellCheckingType = .No
    }

    static func configureForOKCancelAction(cell: AlertCell, type: AlertType, action: AlertAction, textAlignment: NSTextAlignment) {
        cell.background.backgroundColor = .clearColor()
        cell.label.hidden = true
        cell.input.hidden = true
        cell.okButton.hidden = false
        cell.cancelButton.hidden = false
    }

}
