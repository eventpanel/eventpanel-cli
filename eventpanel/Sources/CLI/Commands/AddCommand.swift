import Foundation

final class AddCommand: Command {
    let name = "add"
    let description = "Add event to EventPanel.yaml"
    
    private let fileManager: FileManager
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    func execute(with arguments: [String]) throws {
        guard !arguments.isEmpty else {
            throw CommandError.invalidArguments("""
                Usage: eventpanel add <event_name> --target <target_name>
                Example: eventpanel add 'Button Tapped' --target 'MyApp'
                """)
        }
        
        // Parse arguments
        let eventName = arguments[0]
        guard arguments.count >= 3,
              arguments[1] == "--target",
              !arguments[2].isEmpty else {
            throw CommandError.invalidArguments("Target must be specified with --target flag")
        }
        let targetName = arguments[2]
        
        // Get current directory and EventPanel.yaml path
        let currentPath = fileManager.currentDirectoryPath
        let eventfilePath = (currentPath as NSString).appendingPathComponent("EventPanel.yaml")
        
        guard fileManager.fileExists(atPath: eventfilePath) else {
            throw CommandError.projectIsNotInitilized("No `EventPanel.yaml' found in the project directory.")
        }
        
        do {
            let eventPanelYaml = try EventPanelYaml(path: eventfilePath)
            try eventPanelYaml.addEvent(name: eventName, to: targetName)
            ConsoleLogger.success("Added event '\(eventName)' to target '\(targetName)'")
        } catch EventPanelYaml.Error.targetNotFound(let message) {
            throw CommandError.invalidArguments(message)
        } catch EventPanelYaml.Error.eventAlreadyExists(let event, let target) {
            throw CommandError.invalidArguments("Event '\(event)' already exists in target '\(target)'")
        }
    }
} 
