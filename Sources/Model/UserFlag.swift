////
///  UserFlag.swift
//

enum UserFlag: String {
    case spam = "Spam"
    case violence = "Violence"
    case copyright = "Copyright infringement"
    case threatening = "Threatening"
    case hate = "Hate Speech"
    case adult = "NSFW Content"
    case dontLike = "I don't like it"

    var name: String {
        return self.rawValue
    }

    var kind: String {
        switch self {
        case .spam: return "spam"
        case .violence: return "violence"
        case .copyright: return "copyright"
        case .threatening: return "threatening"
        case .hate: return "hate_speech"
        case .adult: return "adult"
        case .dontLike: return "offensive"
        }
    }

    static let all = [spam, violence, copyright, threatening, hate, adult, dontLike]
}
