import Foundation

// MARK: - NetworkError

class NetworkError: Codable, Error {
    let message: String?
    let code: String?

    init(message: String?, code: String) {
        self.message = message
        self.code = code
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        code = try? container.decode(String.self, forKey: .code)
        message = try? container.decode(String.self, forKey: .message)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(message, forKey: "message")
        aCoder.encode(code, forKey: "code")
    }
}
