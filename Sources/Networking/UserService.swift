////
///  UserService.swift
//

import Moya
import SwiftyJSON
import FutureKit


public struct UserService {

    public init(){}

    public func join(
        email email: String,
        username: String,
        password: String,
        invitationCode: String? = nil) -> Future<User>
    {
        let promise = Promise<User>()
        ElloProvider.shared.elloRequest(ElloAPI.Join(email: email, username: username, password: password, invitationCode: invitationCode),
            success: { (data, responseConfig) in
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

    public func setUserCategories(userId userId: String, categories: [Category]) -> Future<Void> {
        let promise = Promise<Void>()
        let categoryIds = categories.map { $0.id }
        ElloProvider.shared.elloRequest(ElloAPI.UserCategories(userId: userId, categoryIds: categoryIds),
            success: { _ in
                promise.completeWithSuccess(Void())
            },
            failure: { error, _ in
                promise.completeWithFail(error)
            })
        return promise.future
    }
}
