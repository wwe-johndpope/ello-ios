////
///  ElloURI.swift
//

import Keys


class ElloURIWrapper: NSObject {
    let uri: ElloURI
    init(uri: ElloURI) { self.uri = uri }
}

enum ElloURI: String {
    // more specific
    case artistInvitesBrowse = "artist-invites/?$"
    case artistInvitesDetail = "artist-invites/([^/]+)/?$"
    case betaPublicProfiles = "beta-public-profiles/?$"
    case category = "discover/([^/]+)/?$"
    case confirm = "confirm/?$"
    case discover = "discover(/featured|/recommended)?/?$"
    case discoverRandom = "discover/random/?$"
    case discoverRecent = "discover/recent/?$"
    case discoverRelated = "discover/related/?$"
    case discoverTrending = "discover/trending/?$"
    case email = "(.+)@(.+)\\.([a-z]{2,})/?$"
    case enter = "enter/?$"
    case exit = "exit/?$"
    case explore = "explore/?$"
    case exploreRecent = "explore/recent/?$"
    case exploreRecommended = "explore/recommended/?$"
    case exploreTrending = "explore/trending/?$"
    case external = "https?://.{3,}"
    case faceMaker = "facemaker/?$"
    case following = "following/?$"
    case forgotMyPassword = "forgot-password/?$"
    case freedomOfSpeech = "freedom-of-speech/?$"
    case friends = "friends/?$"
    case invitations = "invitations/?$"
    case invite = "join/([^/]+)/?$"
    case join = "join/?$"
    case login = "login/?$"
    case manifesto = "manifesto/?$"
    case nativeRedirect = "native_redirect/?$"
    case noise = "noise/?$"
    case notifications = "notifications(?:/?|/([^/]+)/?)$"
    case onboarding = "onboarding/?$"
    case passwordResetError = "password-reset-error/?$"
    case post = "post/([^/]+)/?$"           // usernameRegex gets prepended
    case profile = "(?:\\?.*?)?$"           // usernameRegex gets prepended
    case profileFollowers = "/followers/?$" // usernameRegex gets prepended
    case profileFollowing = "/following/?$" // usernameRegex gets prepended
    case profileLoves = "/loves/?$"         // usernameRegex gets prepended
    case pushNotificationArtistInvite = "notifications/artist-invites/([^/]+)$"
    case pushNotificationComment = "notifications/posts/([^/]+)/comments/([^/]+)$"
    case pushNotificationPost = "notifications/posts/([^/]+)/?$"
    case pushNotificationUser = "notifications/users/([^/]+)/?$"
    case randomSearch = "random_searches/?$"
    case requestInvitation = "request-an-invitation/?$"
    case requestInvitations = "request_invitations/?$"
    case requestInvite = "request-an-invite/?$"
    case resetMyPassword = "auth/reset-my-password/?\\?reset_password_token=([^&]+)$"
    case resetPasswordError = "auth/password-reset-error/?$"
    case root = "?$"
    case search = "(search|find)/?(\\?.*)?$"
    case searchPeople = "(search|find)/people/?(\\?.*)?$"
    case searchPosts = "(search|find)/posts/?(\\?.*)?$"
    case settings = "settings/?$"
    case signup = "signup/?$"
    case starred = "starred/?$"
    case subdomain = "//.+(?<!(w{3}|staging))\\."
    case unblock = "unblock/?$"
    case whoMadeThis = "who-made-this/?$"
    case wtf = "(wtf$|wtf/.*$)"

    var loadsInWebViewFromWebView: Bool {
        switch self {
        case .artistInvitesBrowse,
             .artistInvitesDetail,
             .discover,
             .category,
             .email,
             .enter,
             .explore,
             .following,
             .starred,
             .notifications,
             .post,
             .profile,
             .root,
             .search,
             .settings:
            return false
        default: return true
        }
    }

    var requiresLogin: Bool {
        switch self {
        case .settings, .notifications, .following, .starred, .friends, .noise,
             .invitations, .onboarding, .unblock:
            return true
        default:
            return false
        }
    }

    var shouldLoadInApp: Bool {
        switch self {
        case .confirm,
             .email,
             .external,
             .faceMaker,
             .freedomOfSpeech,
             .manifesto,
             .nativeRedirect,
             .passwordResetError,
             .randomSearch,
             .requestInvitation,
             .requestInvitations,
             .requestInvite,
             .resetPasswordError,
             .subdomain,
             .unblock,
             .whoMadeThis:
            return false
        default:
            return true
        }
    }

    static var baseURL: String { return APIKeys.shared.domain }

    // this is taken directly from app/models/user.rb
    static let fuzzyDomain: String = "(?:(?:w{3}\\.)?ello\\.(?:ninja|co)|ello-stag(?:ing|e)\\d?\\.herokuapp\\.com|ello-fg-stage\\d?\\.herokuapp\\.com)"
    static let usernameRegex = "([\\w\\-]+)"
    static var userPathRegex: String { return "\(ElloURI.fuzzyDomain)/\(ElloURI.usernameRegex)\\??.*" }

    static func match(_ url: String) -> (type: ElloURI, data: String?) {
        let trimmed = ElloURI.replaceElloScheme(url)
        for type in self.all where trimmed.range(of: type.regexPattern, options: .regularExpression) != nil {
            return (type, type.data(trimmed))
        }
        return (self.external, self.external.data(trimmed))
    }

    private var regexPattern: String {
        switch self {
        case .email,
             .external:
            return rawValue
        case .artistInvitesBrowse,
             .artistInvitesDetail,
             .category,
             .invite,
             .notifications,
             .search:
            return "\(ElloURI.fuzzyDomain)/\(rawValue)"
        case .pushNotificationArtistInvite,
             .pushNotificationComment,
             .pushNotificationPost,
             .pushNotificationUser:
            return "\(rawValue)"
        case .post,
             .profile,
             .profileFollowers,
             .profileFollowing,
             .profileLoves:
            return "\(ElloURI.userPathRegex)\(rawValue)"
        case .subdomain:
            return "\(rawValue)\(ElloURI.fuzzyDomain)"
        default:
            return "\(ElloURI.fuzzyDomain)/\(rawValue)"
        }
    }

    private static func replaceElloScheme(_ path: String) -> String {
        if path.hasPrefix("ello://") {
            return path.replacingOccurrences(of: "ello://", with: "\(baseURL)/")
        }
        return path
    }

    private func data(_ url: String) -> String? {
        let regex = Regex(self.regexPattern)
        switch self {
        case .discover:
            return "recommended"
        case .discoverRandom:
            return "random"
        case .discoverRecent:
            return "recent"
        case .discoverRelated:
            return "related"
        case .discoverTrending:
            return "trending"
        case .artistInvitesDetail:
            return regex?.matchingGroups(url).safeValue(1)
        case .category:
            return regex?.matchingGroups(url).safeValue(1)
        case .invite:
            return regex?.matchingGroups(url).safeValue(1)
        case .notifications:
            return regex?.matchingGroups(url).safeValue(1)
        case .profileFollowers, .profileFollowing, .profileLoves:
            return regex?.matchingGroups(url).safeValue(1)
        case .post:
            let last = regex?.matchingGroups(url).safeValue(2)
            let lastArr = last?.characters.split { $0 == "?" }.map { String($0) }
            return lastArr?.first ?? last
        case .pushNotificationArtistInvite:
            return regex?.matchingGroups(url).safeValue(1)
        case .pushNotificationComment:
            return regex?.matchingGroups(url).safeValue(1)
        case .pushNotificationPost:
            return regex?.matchingGroups(url).safeValue(1)
        case .pushNotificationUser:
            return regex?.matchingGroups(url).safeValue(1)
        case .profile:
            return regex?.matchingGroups(url).safeValue(1)
        case .resetMyPassword:
            return regex?.matchingGroups(url).safeValue(1)
        case .search, .searchPosts, .searchPeople:
            guard let urlComponents = URLComponents(string: url),
                let queryItems = urlComponents.queryItems,
                let terms = (queryItems.filter { $0.name == "terms" }.first?.value)
            else { return nil }
            return terms
        default:
            return nil
        }
    }

    // Order matters: [most specific ... most generic]
    static let all: [ElloURI] = [
        .email,
        .subdomain,
        .post,
        .wtf,
        .root,
        // generic / pages
        .betaPublicProfiles,
        .confirm,
        .discover,
        .discoverRandom,
        .discoverRecent,
        .discoverRelated,
        .discoverTrending,
        .category,
        .artistInvitesBrowse,
        .artistInvitesDetail,
        .enter,
        .exit,
        .explore,
        .exploreRecommended,
        .exploreRecent,
        .exploreTrending,
        .forgotMyPassword,
        .freedomOfSpeech,
        .faceMaker,
        .friends,
        .following,
        .invitations,
        .invite,
        .join,
        .signup,
        .login,
        .manifesto,
        .nativeRedirect,
        .noise,
        .pushNotificationArtistInvite,
        .pushNotificationComment,
        .pushNotificationPost,
        .pushNotificationUser,
        .notifications,
        .onboarding,
        .passwordResetError,
        .randomSearch,
        .requestInvite,
        .requestInvitation,
        .requestInvitations,
        .resetMyPassword,
        .resetPasswordError,
        .searchPeople,
        .searchPosts,
        .search,
        .settings,
        .starred,
        .unblock,
        .whoMadeThis,
        // profile specific
        .profileFollowing,
        .profileFollowers,
        .profileLoves,
        .profile,
        // anything else
        .external,
    ]
}
