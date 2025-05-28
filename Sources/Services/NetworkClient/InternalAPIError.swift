import Foundation

enum InternalAPIError: Error, LocalizedError {
    case unacceptableStatusCode(Int)

    var errorDescription: String? {
        switch self {
        case .unacceptableStatusCode(let statusCode):
            return "Response status code was unacceptable: \(statusCode)."
        }
    }
}
