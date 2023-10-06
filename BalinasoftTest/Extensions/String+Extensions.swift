import Foundation

// MARK: - String

extension String? {
    func orEmpty() -> String {
        guard let str = self else { return "" }
        return str
    }
}
