import Foundation

// MARK: - RequestMethod

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
}

// MARK: - BaseRequest

class BaseRequest {
    var apiConfig: RequestConfigs

    var method = RequestMethod.get
    var path = ""
    var pathParams = [String: Any]()
    var queryParams = [String: Any]()
    var body = [String: Any]()
    var headers = [String: String]()
    var files = [FileRequestInfo: Data]()

    init(apiConfig: RequestConfigs = ApiConfig()) {
        self.apiConfig = apiConfig
    }
}

// MARK: - FileRequestInfo

struct FileRequestInfo: Hashable {
    let name: String
    let fileName: String?

    init(name: String, fileName: String? = nil) {
        self.name = name
        self.fileName = fileName
    }
}
