import Foundation

// MARK: - RequestConfigs

protocol RequestConfigs {
    var baseUrl: String { get }
    var headers: [String: String] { get set }
}

// MARK: - ApiConfig

class ApiConfig: RequestConfigs {
    var baseUrl = "https://junior.balinasoft.com/api/v2"

    var headers = [String: String]()
}

