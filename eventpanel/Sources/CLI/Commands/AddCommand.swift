import Foundation

private enum AddCommandError: LocalizedError {
    case missingArguments
    case missingTarget
    case targetNotFound(String)
    case eventAlreadyExists(event: String, target: String)
    
    var errorDescription: String? {
        switch self {
        case .missingArguments:
            return """
                Usage: eventpanel add <event_name> --target <target_name>
                Example: eventpanel add 'Button Tapped' --target 'MyApp'
                """
        case .missingTarget:
            return "Target must be specified with --target flag"
        case .targetNotFound(let message):
            return message
        case .eventAlreadyExists(let event, let target):
            return "Event '\(event)' already exists in target '\(target)'"
        }
    }
}

final class AddCommand: Command {
    let name = "add"
    let description = "Add event to EventPanel.yaml"
    
    private let fileManager: FileManager
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    func execute(with arguments: [String]) async throws {
        guard !arguments.isEmpty else {
            throw AddCommandError.missingArguments
        }
        
        // Parse arguments
        let eventName = arguments[0]
        guard arguments.count >= 3,
              arguments[1] == "--target",
              !arguments[2].isEmpty else {
            throw AddCommandError.missingTarget
        }
        let targetName = arguments[2]
        
        // Get current directory and EventPanel.yaml path
        let currentPath = fileManager.currentDirectoryPath
        let eventfilePath = (currentPath as NSString).appendingPathComponent("EventPanel.yaml")
        
        guard fileManager.fileExists(atPath: eventfilePath) else {
            throw CommandError.projectIsNotInitialized
        }
        
        do {
            let eventPanelYaml = try EventPanelYaml(path: eventfilePath)
            try eventPanelYaml.addEvent(name: eventName, to: targetName)
            ConsoleLogger.success("Added event '\(eventName)' to target '\(targetName)'")
        } catch EventPanelYaml.Error.targetNotFound(let message) {
            throw AddCommandError.targetNotFound(message)
        } catch EventPanelYaml.Error.eventAlreadyExists(let event, let target) {
            throw AddCommandError.eventAlreadyExists(event: event, target: target)
        }
    }
} 
