import Foundation
import Get

/// Represents the parsed arguments for the add command
private struct AddCommandArguments {
    let eventId: String
    let targetName: String
}

enum AddCommandError: LocalizedError {
    case missingArguments
    case missingTarget
    case targetNotFound(String)
    case eventAlreadyExists(event: String, target: String)
    case eventValidationFailed(String)
    case eventNotFound(eventId: String)

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
        case .eventValidationFailed(let message):
            return "Event validation failed: \(message)"
        case .eventNotFound(let eventId):
            return "Unable to find a specification for event `\(eventId)`"
        }
    }
}

final class AddCommand: Command {
    let name = "add"
    let description = "Add event to EventPanel.yaml"
    
    private let networkClient: NetworkClient
    private let fileManager: FileManager
    
    init(networkClient: NetworkClient, fileManager: FileManager = .default) {
        self.networkClient = networkClient
        self.fileManager = fileManager
    }
    
    func execute(with arguments: [String]) async throws {
        // Part 1: Parse and validate arguments
        let parsedArgs = try parseArguments(arguments)
        
        // Part 2: Validate event with network request
        try await validateEvent(eventId: parsedArgs.eventId)

        // Part 3: Add event to YAML file
        try addEventToYaml(eventId: parsedArgs.eventId, target: parsedArgs.targetName)

        ConsoleLogger.success("Added event '\(parsedArgs.eventId)' to target '\(parsedArgs.targetName)'")
    }
    
    // MARK: - Private Methods
    
    /// Parses and validates command line arguments
    private func parseArguments(_ arguments: [String]) throws -> AddCommandArguments {
        guard !arguments.isEmpty else {
            throw AddCommandError.missingArguments
        }
        
        let eventId = arguments[0]
        
        guard arguments.count >= 3,
              arguments[1] == "--target",
              !arguments[2].isEmpty else {
            throw AddCommandError.missingTarget
        }
        
        return AddCommandArguments(
            eventId: eventId,
            targetName: arguments[2]
        )
    }
    
    /// Validates the event name with the server
    private func validateEvent(eventId: String) async throws {
        do {
            // Make a GET request to validate the event name
            try await networkClient.send(
                Request(path: "api/external/events/validate/\(eventId)", method: .get)
            )

            ConsoleLogger.debug("Event '\(eventId)' validation successful")
        } catch let error as APIError {
            if case .unacceptableStatusCode(404) = error {
                throw AddCommandError.eventNotFound(eventId: eventId)
            }
            throw AddCommandError.eventValidationFailed(error.localizedDescription)
        } catch {
            throw AddCommandError.eventValidationFailed(error.localizedDescription)
        }
    }
    
    /// Adds the validated event to the YAML configuration
    private func addEventToYaml(eventId: String, target: String) throws {
        let currentPath = fileManager.currentDirectoryPath
        let eventfilePath = (currentPath as NSString).appendingPathComponent("EventPanel.yaml")
        
        guard fileManager.fileExists(atPath: eventfilePath) else {
            throw CommandError.projectIsNotInitialized
        }
        
        let eventPanelYaml = try EventPanelYaml(path: eventfilePath)
        try eventPanelYaml.addEvent(eventId: eventId, to: target)
    }
}

// MARK: - Network Models

private struct EventValidationResponse: Decodable {
    let isValid: Bool
    let message: String?
} 
