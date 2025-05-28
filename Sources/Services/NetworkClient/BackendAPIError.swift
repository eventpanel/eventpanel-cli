import Foundation

struct BackendAPIError: LocalizedError {
    let status: Int
    let error: String
    let message: String

    var errorDescription: String? {
        return message
    }
}

extension BackendAPIError: Decodable {
    enum CodingKeys: String, CodingKey {
        case status
        case error
        case message
    }
}
