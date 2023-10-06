import Foundation

// MARK: - Bindable

protocol Bindable: RequestBuilding, RequestSending {
    associatedtype ResponseType: Codable
    func exec(completion: @escaping (_ result: Result<Response<ResponseType>>) -> Void)
}

// MARK: - ResponseData

struct ResponseData<T>: Codable where T: Codable {
    let status: String
    let data: T?
    let message: String?
}

// MARK: - Response

struct Response<T> {
    public var array: [T]
    public var object: T { array.first! }
}

// MARK: - Bindable

extension Bindable where ResponseType: Codable {
    func exec(completion: @escaping (_ result: Result<Response<ResponseType>>) -> Void) {
        guard let urlRequest = urlRequest else { completion(Result.error(RequestBuildError.badURL)); return }
        print("-> \(urlRequest.httpMethod!) \(urlRequest.url!.absoluteString)")

        send(request: urlRequest) { result in
            switch result {
            case .error(let error):
                completion(Result.error(error))

            case .value(let tuple):
                do {
                    guard
                        let response = try self.processRequest(
                            request: urlRequest,
                            httpResponse: tuple.0,
                            data: tuple.1
                        ) else { return }
                    completion(Result.value(response))
                } catch {
                    print(result)
                    completion(Result.error(error))
                }
            }
        }
    }

    private func processRequest(
        request: URLRequest,
        httpResponse: HTTPURLResponse?,
        data: Data
    ) throws -> Response<ResponseType>? {
        print("<- \(request.httpMethod!) \(request.url!.absoluteString) [\(httpResponse!.statusCode)]")

        if let JSONString = String(data: data, encoding: .utf8) {
            print("\(JSONString)")

            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = Date.DateFormatType.server.rawValue
            decoder.dateDecodingStrategy = .formatted(formatter)

            let statusCode = httpResponse?.statusCode ?? .zero
            if httpResponse == nil || (statusCode >= 200 && statusCode < 300) {
                if
                    let response = try? decoder.decode(ResponseData<ResponseType>.self, from: data),
                    response.status == "success",
                    let data = response.data
                {
                    return Response<ResponseType>(array: [data])
                } else if
                    let response = try? decoder.decode(ResponseData<[ResponseType]>.self, from: data),
                    response.status == "success",
                    let data = response.data
                {
                    return Response<ResponseType>(array: data)
                } else {
                    if JSONString.hasPrefix("[") {
                        do {
                            let response = try decoder.decode([ResponseType].self, from: data)
                            return Response<ResponseType>(array: response)
                        } catch {
                            print(error)
                        }
                    } else {
                        let JSONString = !JSONString.isEmpty ? JSONString : "{}"
                        do {
                            let response = try decoder.decode(
                                ResponseType.self,
                                from: JSONString.data(using: .utf8) ?? data
                            )
                            return Response<ResponseType>(array: [response])
                        } catch {
                            print(error)
                        }
                    }
                }
            } else {
                let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                throw errorResponse.error
            }
        }
        throw URLError(.badServerResponse)
    }
}
