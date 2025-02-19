import Foundation

enum CommandError: LocalizedError {
    case invalidArguments(String)
    case fileSystemError(String)
    case fileAlreadyExists(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidArguments(let message):
            return message
        case .fileSystemError(let message):
            return "File system error: \(message)"
        case .fileAlreadyExists(let message):
            return message
        }
    }
} 
