import Foundation

enum CommandError: LocalizedError {
    case projectIsNotInitialized

    var errorDescription: String? {
        switch self {
        case .projectIsNotInitialized:
            return "No `EventPanel.yaml' found in the project directory"
        }
    }
} 
