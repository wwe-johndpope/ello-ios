////
///  DrawerCellPresenter.swift
//

public struct DrawerCellPresenter {

    public static func configure(cell: DrawerCell, item: DrawerItem) {
        switch item.type {
        case .Version:
            cell.label.font = UIFont.defaultFont(12)
            cell.label.textColor = .greyA()
            cell.line.hidden = true
        default:
            cell.label.font = UIFont.defaultFont()
            cell.label.textColor = .whiteColor()
            cell.line.hidden = false
        }

        cell.label.text = item.name
        cell.selectionStyle = .None
    }
}
