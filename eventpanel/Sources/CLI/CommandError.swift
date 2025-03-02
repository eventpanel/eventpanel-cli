import Foundation

enum CommandError: LocalizedError {
    case invalidArguments(String)
    case fileSystemError(String)
    case fileAlreadyExists(String)
    case invalidProject(String)
    case projectIsNotInitilized(String)

    var errorDescription: String? {
        switch self {
        case .invalidArguments(let message):
            return message
        case .fileSystemError(let message):
            return "File system error: \(message)"
        case .fileAlreadyExists(let message):
            return message
        case .invalidProject(let message):
            return message
        case .projectIsNotInitilized(let message):
            return message
        }
    }
} 
