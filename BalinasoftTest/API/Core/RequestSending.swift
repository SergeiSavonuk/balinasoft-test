import Foundation

// MARK: - RequestSending

public protocol RequestSending {
    func send(request: URLRequest, completion: @escaping (_ result: Result<(HTTPURLResponse, Data)>) -> Void)
}

// MARK: - RequestSending

extension RequestSending {
    func send(request: URLRequest, completion: @escaping (_ result: Result<(HTTPURLResponse, Data)>) -> Void) {
        guard request.url != nil else {
            completion(Result.error(RequestBuildError.badURL))
            return
        }
        sendRequest(request: request, session: URLSession.shared, completion: completion)
    }

    func sendRequest(
        request: URLRequest,
        session: URLSession,
        completion: @escaping (_ result: Result<(HTTPURLResponse, Data)>) -> Void
    ) {
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let error = error else {
                    completion(Result.value((response as! HTTPURLResponse, data!)))
                    return
                }
                completion(Result.error(error))
            }
        }.resume()
    }
}
