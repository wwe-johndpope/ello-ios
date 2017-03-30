////
///  UserService.swift
//

import Moya
import SwiftyJSON
import FutureKit


struct UserService {

    init(){}

    func join(
        email: String,
        username: String,
        password: String,
        invitationCode: String?) -> Future<User>
    {
        let promise = Promise<User>()
        ElloProvider.shared.elloRequest(ElloAPI.join(email: email, username: username, password: password, invitationCode: invitationCode),
            success: { data, _ in
                if let user = data as? User {
                    promise.completeWithSuccess(user)
                }
                else {
                    let error = NSError.uncastableJSONAble()
                    promise.completeWithFail(error)
                }
            },
            failure: { error, _ in
                promise.completeWithFail(error)
            }
        )
        return promise.future
    }

    func requestPasswordReset(email: String) -> Future<()> {
        let promise = Promise<()>()
        ElloProvider.shared.elloRequest(ElloAPI.requestPasswordReset(email: email),
            success: { _ in
                promise.completeWithSuccess(())
            },
            failure: { error, _ in
                promise.completeWithFail(error)
            }
        )
        return promise.future
    }

    func resetPassword(password: String, authToken: String) -> Future<()> {
        let promise = Promise<()>()
        ElloProvider.shared.elloRequest(ElloAPI.resetPassword(password: password, authToken: authToken),
            success: { _ in
                promise.completeWithSuccess(())
            },
            failure: { error, _ in
                promise.completeWithFail(error)
            }
        )
        return promise.future
    }

    func setUser(categories: [Category]) -> Future<Void> {
        let promise = Promise<Void>()
        let categoryIds = categories.map { $0.id }
        ElloProvider.shared.elloRequest(ElloAPI.userCategories(categoryIds: categoryIds),
            success: { _ in
                promise.completeWithSuccess(Void())
            },
            failure: { error, _ in
                promise.completeWithFail(error)
            })
        return promise.future
    }
}
