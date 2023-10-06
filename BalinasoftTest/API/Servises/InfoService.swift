import Foundation

// MARK: - InfoRequestService

protocol InfoRequestService {
    func fetchInfo(
        page: Int,
        completion: @escaping (_ result: Result<Response<InfoResponse>>) -> Void
    )
}

// MARK: - InfoRequestServiceImpl

class InfoRequestServiceImpl {
    func fetchInfo(
        page: Int,
        completion: @escaping (_ result: Result<Response<InfoResponse>>) -> Void
    ) {
        InfoRequest(page: page).exec { result in
            switch result {
            case let .value(response):
                completion(Result.value(response))

            case let .error(error):
                completion(Result.error(error))
            }
        }
    }
}

// MARK: - InfoRequestService

extension InfoRequestServiceImpl: InfoRequestService {}
