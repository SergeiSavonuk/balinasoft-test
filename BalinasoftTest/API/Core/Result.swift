import Foundation

// MARK: - CompletionResult

public typealias CompletionResult<ResponseType> = (Result<ResponseType>) -> Void

// MARK: - Result

public enum Result<T> {
    case value(T)
    case error(Error)
}
