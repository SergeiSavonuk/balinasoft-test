// MARK: - InfoResponse

public struct InfoResponse: Codable {
    public let page: Int?
    public let pageSize: Int?
    public let totalPages: Int?
    public let totalElements: Int?
    public let content: [Content]?
}
