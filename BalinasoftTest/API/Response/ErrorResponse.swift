// MARK: - ErrorResponse

class ErrorResponse: Codable, Error {
    let error: NetworkError
}
