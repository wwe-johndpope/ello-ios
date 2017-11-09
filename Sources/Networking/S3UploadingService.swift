////
///  S3UploadingService.swift
//

import PromiseKit


class S3UploadingService {
    var uploader: ElloS3?
    let endpoint: ElloAPI

    init(endpoint: ElloAPI = .amazonCredentials) {
        self.endpoint = endpoint
    }

    func upload(imageRegionData image: ImageRegionData) -> Promise<URL?> {
        if let data = image.data, let contentType = image.contentType {
            return upload(data as Data, contentType: contentType)
        }
        else {
            return upload(image.image)
        }
    }

    func upload(_ image: UIImage) -> Promise<URL?> {
        let (promise, resolve, reject) = Promise<URL?>.pending()
        inBackground {
            if let data = UIImageJPEGRepresentation(image, AppSetup.shared.imageQuality) {
                // Head back to the thread the original caller was on before heading into the service calls. I may be overthinking it.
                nextTick {
                    self.upload(data, contentType: "image/jpeg").then(execute: resolve).catch(execute: reject)
                }
            }
            else {
                let error = NSError(domain: ElloErrorDomain, code: 500, userInfo: [NSLocalizedFailureReasonErrorKey: InterfaceString.Error.JPEGCompress])
                reject(error)
            }
        }
        return promise
    }

    func upload(_ text: String, filename: String) -> Promise<URL?> {
        guard let data = text.data(using: .utf8) else {
            let error = NSError(domain: ElloErrorDomain, code: 500, userInfo: [NSLocalizedFailureReasonErrorKey: "bad data"])
            return Promise<URL?>(error: error)
        }

        return upload(data, contentType: "text/plain", filename: filename)
    }

    func upload(_ data: Data, contentType: String, filename overrideFilename: String? = nil) -> Promise<URL?> {
        return ElloProvider.shared.request(endpoint)
            .then { response -> Promise<URL?> in
                guard let credentials = response.0 as? AmazonCredentials else {
                    throw NSError.uncastableJSONAble()
                }

                let filename: String
                if let overrideFilename = overrideFilename {
                    filename = overrideFilename
                }
                else {
                    switch contentType {
                    case "image/gif":
                        filename = "\(UUID().uuidString).gif"
                    case "image/png":
                        filename = "\(UUID().uuidString).png"
                    case "text/plain":
                        filename = "\(UUID().uuidString).txt"
                    default:
                        filename = "\(UUID().uuidString).jpg"
                    }
                }

                return ElloS3(credentials: credentials, filename: filename, data: data, contentType: contentType)
                    .start()
                    .then { data -> URL? in
                        let endpoint: String = credentials.endpoint
                        let prefix: String = credentials.prefix
                        return URL(string: "\(endpoint)/\(prefix)/\(filename)")
                    }
            }
    }
}
