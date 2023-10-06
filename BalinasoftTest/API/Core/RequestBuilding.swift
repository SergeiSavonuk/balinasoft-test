import Foundation
import UIKit

// MARK: - Constants

private enum Constants {
    static let timeoutInterval: Double = 15
}

// MARK: - RequestBuildError

enum RequestBuildError: Error {
    case badURL
}

// MARK: - RequestBuilding

protocol RequestBuilding {
    var urlRequest: URLRequest? { get }
}

// MARK: - BaseRequest

extension BaseRequest: RequestBuilding {
    @objc var urlRequest: URLRequest? {
        guard let url = url else { return nil }
        var req = URLRequest(url: url)
        req.httpMethod = method.rawValue
        req.httpBody = httpBody
        req.timeoutInterval = Constants.timeoutInterval
        req.allHTTPHeaderFields = apiConfig.headers

        if headers.count > 0 {
            headers.forEach { key, value in
                req.allHTTPHeaderFields![key] = value
            }
        }
        return req
    }

    var url: URL? {
        guard let baseURL = URL(string: apiConfig.baseUrl) else { return nil }
        guard var URLComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else { return nil }

        URLComponents.path += pathWithParams
        URLComponents.queryItems = parametersAsQueryItems

        return URLComponents.url
    }

    private var pathWithParams: String {
        var str = path
        pathParams.forEach { key, value in
            str = str.replacingOccurrences(of: "{\(key)}", with: "\(value)")
        }
        return str
    }

    private var httpBody : Data? {
        if body.count > 0 {
            print(JSONSerialization.isValidJSONObject(body))
            
            return try? JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        } else if files.count > 0 {
            let boundary = UUID().uuidString
            headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
            var body = Data()
            for (k, v) in files.sorted(by: { $0.key.name < $1.key.name } ) {
                let name = k.name
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                if let fileName = k.fileName {
                    body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
                    body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
                } else {
                    body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
                }
                body.append(v)
                body.append("\r\n".data(using: .utf8)!)
            }
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            return body
        }
        return nil
    }

    private var parametersAsQueryItems: [URLQueryItem]? {
        guard !queryParams.isEmpty else { return nil }
        return queryParams.map { key, value in
            URLQueryItem(name: key, value: (value as AnyObject).description)
        }
    }
}

