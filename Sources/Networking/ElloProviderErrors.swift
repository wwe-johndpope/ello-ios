////
///  ElloProviderErrors.swift
//

extension ElloProvider {

    static func unCastableJSONAble(_ failure: ElloFailureCompletion) {
        let elloError = NSError.uncastableJSONAble()
        failure(elloError, 200)
    }

    static func generateElloError(_ data: Data?, statusCode: Int?) -> NSError {
        var elloNetworkError: ElloNetworkError?

        if let data = data {
            let (mappedJSON, _): (Any?, NSError?) = Mapper.mapJSON(data)
            let dictJSON = mappedJSON as? [String: Any]

            if dictJSON != nil {
                if let node = dictJSON?[MappingType.errorsType.rawValue] as? [String: Any] {
                    elloNetworkError = Mapper.mapToObject(node, type: MappingType.errorType) as? ElloNetworkError
                }
            }
        }
        else if statusCode == 401 {
            elloNetworkError = ElloNetworkError(attrs: nil, code: .unauthenticated, detail: nil, messages: nil, status: "401", title: "unauthenticated")
        }

        let errorCodeType = (statusCode == nil) ? ElloErrorCode.data : ElloErrorCode.statusCode
        let elloError = NSError.networkError(elloNetworkError, code: errorCodeType)

        return elloError
    }

    static func failedToSendRequest(_ failure: ElloFailureCompletion) {
        let elloError = NSError.networkError("Failed to send request", code: ElloErrorCode.networkFailure)
        failure(elloError, nil)
    }

    static func failedToMapObjects(_ failure: ElloFailureCompletion) {
        let jsonMappingError = ElloNetworkError(attrs: nil, code: ElloNetworkError.CodeType.unknown, detail: "NEED DEFAULT HERE", messages: nil, status: nil, title: "Unknown Error")
        let elloError = NSError.networkError(jsonMappingError, code: ElloErrorCode.jsonMapping)
        failure(elloError, nil)
    }
}
