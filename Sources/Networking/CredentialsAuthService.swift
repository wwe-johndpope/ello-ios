////
///  CredentialsAuthService.swift
//

import Moya
import PromiseKit


class CredentialsAuthService {

    func authenticate(email: String, password: String) -> Promise<Void> {
        let endpoint: ElloAPI = .auth(email: email, password: password)
        let (promise, fulfill, reject) = Promise<Void>.pending()
        ElloProvider.sharedProvider.request(endpoint) { (result) in
            switch result {
            case let .success(moyaResponse):
                switch moyaResponse.statusCode {
                case 200...299:
                    ElloProvider.shared.authenticated(isPasswordBased: true)
                    AuthToken.storeToken(moyaResponse.data, isPasswordBased: true, email: email, password: password)
                    fulfill(Void())
                default:
                    let elloError = ElloProvider.generateElloError(moyaResponse.data, statusCode: moyaResponse.statusCode)
                    reject(elloError)
                }
            case let .failure(error):
                reject(error)
            }
        }
        return promise
    }

}
