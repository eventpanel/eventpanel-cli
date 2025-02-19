import Foundation

enum CommandError: LocalizedError {
    case invalidArguments(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidArguments(let message):
            return message
        }
    }
} 