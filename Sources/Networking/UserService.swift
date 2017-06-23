////
///  UserService.swift
//

import Moya
import SwiftyJSON
import PromiseKit


struct UserService {

    init(){}

    func join(
        email: String,
        username: String,
        password: String,
        invitationCode: String? = nil) -> Promise<User>
    {
        return ElloProvider.shared.request(.join(email: email, username: username, password: password, invitationCode: invitationCode))
            .then { data, _ -> Promise<User> in
                guard let user = data as? User else {
                    throw NSError.uncastableJSONAble()
                }

                let promise: Promise<User> = CredentialsAuthService().authenticate(email: email, password: password)
                    .then { _ -> User in
                        return user
                    }
                return promise
            }
    }

    func requestPasswordReset(email: String) -> Promise<()> {
        return ElloProvider.shared.request(.requestPasswordReset(email: email))
            .asVoid()
    }

    func resetPassword(password: String, authToken: String) -> Promise<User> {
        return ElloProvider.shared.request(.resetPassword(password: password, authToken: authToken))
            .then { user, _ -> User in
                guard let user = user as? User else {
                    throw NSError.uncastableJSONAble()
                }
                return user
            }
    }

    func setUser(categories: [Category]) -> Promise<()> {
        let categoryIds = categories.map { $0.id }
        return ElloProvider.shared.request(.userCategories(categoryIds: categoryIds))
            .asVoid()
    }
}
