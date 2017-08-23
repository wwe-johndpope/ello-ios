////
///  PromiseKitExtensions.swift
//

import PromiseKit


extension Promise {

    public final class func reject(_ error: Error) -> Promise<T> {
        let (promise, _, reject) = Promise<T>.pending()
        reject(error)
        return promise
    }

    public final class func resolve(_ value: T) -> Promise<T> {
        let (promise, resolve, _) = Promise<T>.pending()
        resolve(value)
        return promise
    }

    func thenFinally(execute body: @escaping (T) throws -> Void) -> Promise<Void> {
        return then(execute: body)
    }

    @discardableResult
    func ignoreErrors() -> Promise<T> {
        self.catch { _ in }
        return self
    }
}
