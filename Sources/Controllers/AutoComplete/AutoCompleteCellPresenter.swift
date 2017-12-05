////
///  AutoCompleteCellPresenter.swift
//

struct AutoCompleteCellPresenter {

    static func configure(_ cell: AutoCompleteCell, item: AutoCompleteItem) {
        if let resultName = item.result.name {
            switch item.type {
            case .emoji:
                cell.name = ":\(resultName):"
            case .username:
                cell.name = "@\(resultName)"
            case .location:
                cell.name = resultName
            }
        }
        else {
            cell.name = ""
        }

        if let image = item.result.image {
            cell.avatar.setUserAvatar(image)
        }
        else if let url = item.result.url {
            cell.avatar.setUserAvatarURL(url)
        }
    }
}
