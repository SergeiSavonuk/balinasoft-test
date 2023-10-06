import Foundation
import UIKit

// MARK: - PhotoRequestService

protocol PhotoRequestService {
    func sendPhoto(
        id: Int,
        photo: UIImage,
        completion: @escaping (_ result: Result<Response<PhotoResponse>>) -> Void
    )
}

// MARK: - PhotoRequestServiceImpl

class PhotoRequestServiceImpl {
    func sendPhoto(
        id: Int,
        photo: UIImage,
        completion: @escaping (_ result: Result<Response<PhotoResponse>>) -> Void
    ) {
        PhotoRequest(id: id, photo: photo).exec { result in
            switch result {
            case let .value(response):
                completion(Result.value(response))

            case let .error(error):
                completion(Result.error(error))
            }
        }
    }
}

// MARK: - PhotoRequestService

extension PhotoRequestServiceImpl: PhotoRequestService {}
